require "cigale/version"
require "slop"
require "yaml"

module Cigale
  class CLI
    def initialize
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

      puts "Input = #{input}, output = #{opts[:output]}"
      f = YAML.load_file(input)
      puts f.first.keys.first
    end
  end
end
