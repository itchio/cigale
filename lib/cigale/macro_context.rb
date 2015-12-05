
require "cigale/exts"

module Cigale
  class MacroContext < Exts
    def initialize (options)
      @library = options[:library]
      @params = options[:params]
      @had_expansions = false
    end

    # get a macro
    def lookup (macro_name)
      mdef = @library[macro_name]
      raise "Undefined macro: #{macro_name} — got #{@library.keys.inspect}" unless mdef
      mdef
    end

    # walk tree, expand macros we find
    def expand (entity)
      case entity
      when Array
        # list of things, need to expand each individually
        entity.map do |x|
          expand(x)
        end
      when Hash
        entity.map do |k, v|
          case k
          when /^\.(.*)$/
            # macro call
            if expanding?
              # keep child macro as-is for later expansion
              [k, expand(v)]
            else
              mdef = lookup($1)

              res = self.with_params(v).expand(mdef)
              case res
              when Hash
                first_pair(res)
              when String, Array
                return res
              else
                raise "Invalid macro expansion result: #{res.inspect}"
              end
            end
          else
            [k, expand(v)]
          end
        end.to_h
      else
        # not a list, not a hash
        interpolate(entity)
      end
    end

    # given "{name}"
    def interpolate (entity)
      return entity unless expanding?

      case entity
      when /^{([a-zA-Z0-9*\. -]*)}$/
        # just paste param verbatim — could be a string,
        # could be a hash, a list, whatever, just jam it in there.
        get_param($1)
      when String
        entity.gsub /{([a-zA-Z0-9*\. -]*)}/ do |m|
          get_param($1)
        end
      else
        entity
      end
    end

    def get_param (spec)
      raise "Found param {#{spec}} outside expansion" unless expanding?

      name, type = spec.split(" ")
      if name == '*'
        return @params
      end

      res = dig(@params, name)
      raise "Unspecified param {#{name}}" unless res
      res
    end

    def with_params (params)
      raise "Can't expand while expanding" if expanding?
      @had_expansions = true
      MacroContext.new(:library => @library, :params => params)
    end

    def had_expansions?
      @had_expansions
    end

    def expanding?
      not @params.nil?
    end
  end
end
