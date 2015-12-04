
require "cigale/macro_context"
require "cigale/exts"
require "cigale/generator"

require "logger"
require "slop"
require "jenkins_api_client"

require "yaml"
require "fileutils"
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
        o.bool "--fixture", "fixture", "Enable fixture mode", :default => false
        o.bool "--masquerade", "masquerade", "Try to pass off as jenkins-job-builder", :default => false
        o.integer "--blowup", "blowup", "Max macro expansion rounds", :default => 1023
        o.string "--test-category", "test_category", "Test category"
        o.string "-l", "loglevel", "Logger level", :default => "INFO"
      end
      @opts = opts

      logger.level = Logger.const_get opts[:loglevel]

      if opts.arguments.empty?
        logger.error "No command given"
        print_usage!
        return
      end

      cmd, input = opts.arguments
      case cmd
      when "test", "dump", "update"
        # all good
      else
        logger.error "Unknown command: #{cmd}"
        exit 1
      end

      unless input
        logger.error "No input given"
        print_usage!
        exit 1
      end

      inputs = if File.directory? input
        Dir.glob(File.join(input, "**", "*.y{a,}ml"))
      else
        [input]
      end

      entries = []

      for input in inputs
        logger.info "Parsing #{input}"
        parsed = YAML.load_file(input)

        unless Array === parsed
          raise "Top-level entity in YAML must be an array" unless opts[:fixture]
          parsed = [{"job" => parsed}]
        end

        entries += parsed
      end

      # sort out macro definitions from actual entries
      @library = {}
      @definitions = []

      for entry in entries
        etype, edef = first_pair(entry)

        case etype
        when Symbol
          # ruby's yaml parses `:key: val` as `:key => val` rather
          # than `":key" => val`, so macro definitions in cigale have symbol keys
          @library[etype.to_s] = edef
        else
          @definitions.push entry
        end
      end

      logger.info "Parsed #{@library.size} macros, #{@definitions.size} job definitions."

      output = opts[:output]
      client = nil

      case cmd
      when "test", "dump"
        logger.info "Creating directory #{output}"
        FileUtils.mkdir_p output
      when "update"
        client = get_client!
        all_jobs = client.job.list_all
        logger.info "Before update, job list: "
        all_jobs.each { |x| logger.info "  - #{x}" }
      end

      for entry in @definitions
        entry = fully_expand(entry)

        etype, edef = first_pair(entry)
        if edef["name"].nil?
          raise "Jobs must have names" unless opts[:fixture]
          edef["name"] = "fixture"
          edef["project-type"] ||= "project"
        end

        job_name = edef["name"]
        job_path = File.join(output, job_name)

        case etype
        when "job"
          case cmd
          when "dump"
            File.open(job_path + ".yml", "w") do |f|
              f.write entry.to_yaml
            end
          else
            xml = ::Builder::XmlMarkup.new(:indent => 2)
            xml.instruct! :xml, :version => "1.0", :encoding => "utf-8"
            translate_job xml, edef

            case cmd
            when "test"
              File.open(job_path + ".xml", "w") do |f|
                f.write(xml.target!)
              end
            when "update"
              client.job.create_or_update(job_name, xml.target!)
            end
          end
        else
          raise "Unknown top-level type: #{etype}"
        end
      end

      logger.info "Generated #{@numjobs} jobs."
    end

    def fully_expand (entry)
      original = entry
      iterations = 0

      # TODO detect circular dependencies instead
      while iterations < @opts[:blowup]
        ctx = MacroContext.new :library => @library
        entry = ctx.expand(entry)
        return entry unless ctx.had_expansions?
        iterations += 1
      end

      raise "Blew up while trying to expand #{original.inspect}"
    end

    def underize (name)
      name.gsub(/-/, '_')
    end

    def print_usage
      puts "cigale v#{VERSION}"
      puts "Usage: cigale [test] -o output/directory [spec file or directory]"
    end

    def get_client!
      config_path = "secret/cigale.yml"
      config = {}

      begin
        config = YAML.load_file(config_path)
      rescue Errno::ENOENT => e
        logger.error "Config file missing: #{config_path}"
        logger.error "Please create one. The `server` section can have any of the fields listed at:"
        logger.error " http://github.arangamani.net/jenkins_api_client/JenkinsApi/Client.html#initialize-instance_method"
        exit 1
      end

      JenkinsApi::Client.new(config["server"])
    end
  end
end
