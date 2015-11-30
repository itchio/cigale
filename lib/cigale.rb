require "cigale/version"
require "logger"
require "slop"
require "yaml"
require "fileutils"
require "builder"

module Cigale
  class CLI
    def initialize
      @logger = Logger.new($stdout).tap do |log|
        log.progname = "cigale"
      end

      opts = Slop.parse ARGV do |o|
        o.banner = "Usage: cigale [options] [spec_file.yml]"

        o.string "-o", "output", "Output directory", :default => "."
      end

      cmd, input = opts.arguments
      case cmd
      when "test"
        # cool
      else
        raise "Unknown command: #{cmd}"
      end

      @logger.info "Parsing #{input}"
      entries = YAML.load_file(input)

      output = opts[:output]
      @logger.info "Creating directory #{output}"
      FileUtils.mkdir_p output

      for entry in entries
        etype, edef = asplode(entry)

        case etype
        when "job"
          xml = Builder::XmlMarkup.new(:indent => 2)
          xml.instruct! :xml, :version => "1.0", :encoding => "utf-8"

          translate_project xml, edef

          job_path = File.join(output, edef["name"])
          File.open(job_path, "w") do |f|
            f.write(xml.target!)
          end
        else
          raise "Unknown top-level type: #{entry_type}"
        end
      end
    end

    def translate_project (xml, jdef)
      project = case jdef["project_type"]
                when "matrix"
                  "matrix-project"
                else
                  "project"
                end

      xml.tag! project do
        case project
        when "matrix-project"
          xml.executionStrategy :class => "hudson.matrix.DefaultMatrixExecutionStrategyImpl" do
            xml.runSequentially false
          end
          xml.combinationFilter
          xml.axes
        end

        xml.actions
        xml.description "<!-- Managed by Jenkins Job Builder -->"
        xml.keepDependencies false
        xml.blockBuildWhenDownstreamBuilding false
        xml.blockBuildWhenUpstreamBuilding false
        xml.concurrentBuild false
        xml.canRoam true
        xml.properties
        translate_scm xml, jdef["scm"]
        translate_builders xml, jdef["builders"]
        xml.publishers
        xml.buildWrappers
      end
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
        stype, sdef = asplode(s)
        clazz = scm_classes[stype]
        raise "Unknown scm type: #{stype}" unless clazz

        xml.scm :class => clazz do
          self.send "translate_#{underize(stype)}_scm", xml, sdef
        end
      end
    end

    def translate_git_scm (xml, sdef)
      xml.configVersion 2
      xml.userRemoteConfigs do
        xml.tag! "hudson.plugins.git.UserRemoteConfig" do
          xml.name sdef["name"] || "origin"
          xml.refspec sdef["refspec"] || "+refs/heads/*:refs/remotes/remoteName/*"
          xml.url sdef["url"]
          xml.credentialsId sdef["credentials-id"]
        end
      end

      xml.branches do
        for branch in sdef["branches"]
          xml.tag! "hudson.plugins.git.BranchSpec" do
            xml.name branch
          end
        end
      end

      xml.excludedUsers
      xml.buildChooser :class => "hudson.plugins.git.util.DefaultBuildChooser"
      xml.disableSubmodules false
      xml.recursiveSubmodules false
      xml.doGenerateSubmoduleConfigurations false
      xml.authorOrCommitter false
      xml.wipeOutWorkspace true
      xml.pruneBranches false
      xml.remotePoll false
      xml.gitTool "Default"
      xml.submoduleCfg :class => "list"
      xml.relativeTargetDir
      xml.reference
      xml.gitConfigName
      xml.gitConfigEmail
      xml.skipTag false
      xml.scmName
      xml.useShallowClone false
      xml.ignoreNotifyCommit false
      xml.extensions do
        xml.tag! "hudson.plugins.git.extensions.impl.WipeWorkspace"
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
      xml.builders do
        for b in builders
          btype, bdef = asplode(b)
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

      stype, sdef = asplode(bdef["steps"].first)
      clazz = builder_classes[stype]
      raise "Unknown builder type: #{stype}" unless clazz

      xml.tag! "buildStep", :class => clazz do
        self.send "translate_#{underize(stype)}_builder", xml, sdef
      end
    end

    def translate_conditional_multi_step_builder (xml, bdef)
      xml.conditionalbuilders do
        for step in bdef["steps"]
          stype, sdef = asplode(step)
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

    def asplode (map)
      return map.keys.first, map.values.first
    end

    def underize (name)
      name.gsub(/-/, '_')
    end
  end
end
