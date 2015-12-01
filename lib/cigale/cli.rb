
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
            xml = ::Builder::XmlMarkup.new(:indent => 2)
            xml.instruct! :xml, :version => "1.0", :encoding => "utf-8"
            translate_job xml, edef

            job_path = File.join(output, edef["name"])
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

    def underize (name)
      name.gsub(/-/, '_')
    end
  end
end
