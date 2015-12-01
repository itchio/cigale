
require "cigale/macro_context"
require "cigale/exts"
require "cigale/generator"

require "logger"
require "slop"

# should be in parser
require "yaml"
require "fileutils"

# should be in backend
require "builder"

module Cigale
  # Command-line interface, need to be exploded further
  class CLI < Exts
    include Cigale::Generator

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = "cigale"
      end
    end

    def initialize (args)
      @numjobs = 0

      opts = Slop.parse args do |o|
        o.banner = "Usage: cigale [options] [command] [spec_file.yml]"

        o.string "-o", "output", "Output directory", :default => "."
        o.bool "-d", "debug", "Enable debug output", :default => false
        o.bool "--fixture", "fixture", "Enable fixture mode", :default => false
        o.string "-l", "loglevel", "Logger level", :default => "INFO"
      end

      logger.level = Logger.const_get opts[:loglevel]

      cmd, input = opts.arguments
      case cmd
      when "test"
        # cool
      when "dump"
        # cool too
      else
        raise "Unknown command: #{cmd}"
      end

      Exts.debug = opts[:debug]

      logger.info "Parsing #{input}"
      entries = YAML.load_file(input)

      unless Array === entries
        raise "Top-level entity in YAML must be an array" unless opts[:fixture]
        entries = [{"job" => entries}]
      end

      output = opts[:output]
      logger.info "Creating directory #{output}"
      FileUtils.mkdir_p output

      library = {}
      concrete_entries = []

      for entry in entries
        etype, edef = first_pair(entry)

        case etype
        when Symbol
          library[etype.to_s] = edef
        else
          concrete_entries.push entry
        end
      end

      for entry in concrete_entries
        while true do
          ctx = MacroContext.new :library => library
          entry = ctx.expand(entry)
          break unless ctx.had_expansions?
        end

        case cmd
        when "dump"
          puts entry.to_yaml
        else
          etype, edef = first_pair(entry)
          if edef["name"].nil?
            raise "Jobs must have names" unless opts[:fixture]
            edef["name"] = "fixture"
            edef["project-type"] = "test"
          end

          case etype
          when "job"
            xml = Builder::XmlMarkup.new(:indent => 2)
            xml.instruct! :xml, :version => "1.0", :encoding => "utf-8"
            translate_job xml, edef

            job_path = File.join(output, edef["name"] + ".xml")
            File.open(job_path, "w") do |f|
              f.write(xml.target!)
            end
          else
            raise "Unknown top-level type: #{etype}"
          end
        end
      end

      logger.info "Generated #{@numjobs} jobs."
    end


    def scm_classes
      @scm_classes ||= {
        "nil" => "hudson.scm.NullSCM",
        "git" => "hudson.plugins.git.GitSCM",
      }
    end

    def translate_scm (xml, scms)
      if scms.nil?
        return xml.scm :class => scm_classes["nil"]
      end

      for s in scms
        stype, sdef = first_pair(s)
        clazz = scm_classes[stype]
        raise "Unknown scm type: #{stype}" unless clazz

        xml.scm :class => clazz do
          self.send "translate_#{underize(stype)}_scm", xml, sdef
        end
      end
    end

    def translate_triggers (xml, triggers)
      if (triggers || []).size == 0
        return
      end

      xml.triggers :class => "vector" do
        for t in triggers
          case t
          when "github"
            xml.tag! "com.cloudbees.jenkins.GitHubPushTrigger" do
              xml.spec
            end
          else
            raise "Unknown trigger type: #{t}"
          end
        end
      end
    end

    def builder_classes
      @builder_classes = {
        "inject" => "EnvInjectBuilder",
        "shell" => "hudson.tasks.Shell",
        "batch" => "hudson.tasks.BatchFile",
      }
    end

    def translate_builders (xml, builders)
      if (builders || []).size == 0
        return xml.builders
      end

      xml.builders do
        for b in builders
          btype, bdef = first_pair(b)
          clazz = builder_classes[btype]

          if clazz.nil?
            if btype == "conditional-step"
              translate_conditional_step_builder xml, bdef
            else
              raise "Unknown builder type: #{btype}" unless clazz
            end
          else
            xml.tag! clazz do
              self.send "translate_#{underize(btype)}_builder", xml, bdef
            end
          end
        end
      end
    end

    def translate_inject_builder (xml, bdef)
      xml.info do
        if val = bdef["properties-content"]
          xml.propertiesContent val
        end
      end
    end

    def translate_shell_builder (xml, bdef)
      xml.command bdef
    end

    def translate_batch_builder (xml, bdef)
      xml.command bdef
    end

    def condition_types
      @condition_types = {
        "regex" => "org.jenkins_ci.plugins.run_condition.core.ExpressionCondition",
      }
    end

    def condition_classes
      return @condition_classes = {
        "regex-match" => "org.jenkins_ci.plugins.run_condition.core.ExpressionCondition",
      }
    end

    def translate_conditional_step_builder (xml, bdef)
      case (bdef["steps"] || []).size
      when 0
        raise "Need 1 or more steps for conditional: #{bdef.inspect}"
      when 1
        xml.tag! "org.jenkinsci.plugins.conditionalbuildstep.singlestep.SingleConditionalBuilder" do
          translate_conditional_single_step_builder xml, bdef
        end
      else
        xml.tag! "org.jenkinsci.plugins.conditionalbuildstep.ConditionalBuilder" do
          translate_conditional_multi_step_builder xml, bdef
        end
      end
    end

    def translate_conditional_single_step_builder (xml, bdef)
      translate_condition "condition", xml, bdef

      translate_condition_runner xml, bdef

      stype, sdef = first_pair(bdef["steps"].first)
      clazz = builder_classes[stype]
      raise "Unknown builder type: #{stype}" unless clazz

      xml.tag! "buildStep", :class => clazz do
        self.send "translate_#{underize(stype)}_builder", xml, sdef
      end
    end

    def translate_conditional_multi_step_builder (xml, bdef)
      xml.conditionalbuilders do
        for step in bdef["steps"]
          stype, sdef = first_pair(step)
          clazz = builder_classes[stype]
          raise "Unknown builder type: #{stype}" unless clazz

          xml.tag! clazz do
            self.send "translate_#{underize(stype)}_builder", xml, sdef
          end
        end
      end

      translate_condition "runCondition", xml, bdef

      translate_condition_runner xml, bdef
    end

    def translate_condition (tag, xml, bdef)
      ckind = bdef["condition-kind"] || raise("Missing condition-kind: #{bdef.inspect}")
      cclass = condition_classes[ckind]
      raise "Unknown condition kind: #{ckind}" unless cclass

      xml.tag! tag, :class => cclass do
        case ckind
        when "regex-match"
          xml.expression bdef["regex"] || raise("Missing regex: #{bdef.inspect}")
          xml.label bdef["label"] || raise("Missing label: #{bdef.inspect}")
        end
      end
    end

    def translate_condition_runner (xml, bdef)
      xml.runner :class => "org.jenkins_ci.plugins.run_condition.BuildStepRunner$Fail"
    end

    def underize (name)
      name.gsub(/-/, '_')
    end
  end
end
