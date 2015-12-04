
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
        o.bool "--fixture", "fixture", "Enable fixture mode", :default => false
        o.string "--test-category", "test_category", "Test category"
        o.string "-l", "loglevel", "Logger level", :default => "INFO"
      end
      @opts = opts

      logger.level = Logger.const_get opts[:loglevel]

      if opts.arguments.empty?
        puts "cigale v#{VERSION}"
        puts "Usage: cigale [test] -o output/directory [spec file or directory]"
        return
      end

      cmd, input = opts.arguments
      case cmd
      when "test", "dump"
        # all good
      else
        raise "Unknown command: #{cmd}"
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

      output = opts[:output]
      logger.info "Creating directory #{output}"
      FileUtils.mkdir_p output

      library = {}
      concrete_entries = []

      # sort out macro definitions from actual entries
      for entry in entries
        etype, edef = first_pair(entry)

        case etype
        when Symbol
          library[etype.to_s] = edef
        else
          concrete_entries.push entry
        end
      end

      logger.info "#{library.size} macros, #{concrete_entries.size} jobs."

      for entry in concrete_entries
        while true do
          ctx = MacroContext.new :library => library
          entry = ctx.expand(entry)
          break unless ctx.had_expansions?
        end

        etype, edef = first_pair(entry)
        if edef["name"].nil?
          raise "Jobs must have names" unless opts[:fixture]
          edef["name"] = "fixture"
          edef["project-type"] ||= "project"
        end
        job_path = File.join(output, edef["name"])

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

            File.open(job_path + ".xml", "w") do |f|
              f.write(xml.target!)
            end
          end
        else
          raise "Unknown top-level type: #{etype}"
        end
      end

      logger.info "Generated #{@numjobs} jobs."
    end

    def underize (name)
      name.gsub(/-/, '_')
    end
  end
end
