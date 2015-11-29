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
        log.progname = 'cigale'
      end

      opts = Slop.parse ARGV do |o|
        o.banner = 'Usage: cigale [options] [spec_file.yml]'

        o.string '-o', 'output', 'Output directory', :default => '.'
      end

      cmd, input = opts.arguments
      case cmd
      when "test"
        # cool
      else
        puts "Unknown command: #{cmd}"
        exit 1
      end

      @logger.info "Parsing #{input}" 
      entries = YAML.load_file(input)

      output = opts[:output]
      @logger.info "Creating directory #{output}" 
      FileUtils.mkdir_p output

      for entry in entries
        case entry.keys.first
        when 'job'
          root = entry.values.first

          xml = Builder::XmlMarkup.new(:indent => 2)
          xml.instruct! :xml, :version => "1.0", :encoding => "utf-8"
          xml.tag! 'matrix-project' do
            xml.executionStrategy :class => 'hudson.matrix.DefaultMatrixExecutionStrategyImpl' do
              xml.runSequentially false
            end
            xml.combinationFilter
            xml.axes
            xml.actions
            xml.description "<!-- Managed by Jenkins Job Builder -->"
            xml.keepDependencies false
            xml.blockBuildWhenDownstreamBuilding false
            xml.blockBuildWhenUpstreamBuilding false
            xml.concurrentBuild false
            xml.canRoam true
            xml.properties
            xml.scm :class => "hudson.scm.NullSCM"
            xml.builders
            xml.publishers
            xml.buildWrappers
          end

          job_path = File.join(output, root["name"])
          File.open(job_path, 'w') do |f|
            f.write(xml.target!)
          end
        else
          raise "Unknown top-level type: #{}"
        end
      end
    end
  end
end
