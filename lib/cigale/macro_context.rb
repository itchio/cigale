
require "cigale/mutter"

module Cigale
  class MacroContext < Mutter
    def initialize (options)
      @library = options[:library]
      @expanded = false
    end

    # start expanding
    def start (params)
      raise "Can't expand while expanding" if @expanding

      @expanding = true
      @params = params
    end

    def get_param (spec)
      name, type = spec.split(" ")
      if name == '*'
        mutt "Resolving {#{spec}} =>", @params
        return @params
      end

      res = @params.dig(name)
      raise "Unspecified param {#{name}}" unless res
      mutt "Resolving {#{spec}} =>", res
      res
    end

    def lookup (macro_name)
      mdef = @library[macro_name]
      raise "Undefined macro: #{macro_name} — got #{@library.keys.inspect}" unless mdef
      mdef
    end

    def expanding?
      @expanding
    end
  end
end
