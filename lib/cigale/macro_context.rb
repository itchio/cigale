
require "cigale/exts"

module Cigale
  class Splat
    def initialize (elems)
      @elems = elems
    end

    def elems
      @elems
    end
  end

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
        array = []

        entity.each do |x|
          case child = expand(x)
          when Splat
            array += child.elems
          else
            array << child
          end
        end

        array
      when Hash
        pairs = []

        entity.each do |k, v|
          case k
          when /^\.(.*)$/
            # macro call
            if expanding?
              # keep child macro as-is for later expansion
              pairs << [k, expand(v)]
            else
              splat = false
              mname = $1

              # cf. https://github.com/itchio/cigale/issues/2 for 'spec'
              if mname =~ /^\./
                mname = mname[1..-1]
                splat = true
              end

              params = v
              mdef = lookup(mname)

              # cf. https://github.com/itchio/cigale/issues/3
              case mdef
              when Hash
                if defaults = mdef[:defaults]
                  params = defaults.merge(toh(params))
                  mdef = mdef.dup
                  mdef.delete(:defaults)
                end
              when Array
                case first = mdef.first
                when Hash
                  if defaults = first[:defaults]
                    params = defaults.merge(toh(params))
                    mdef = mdef.dup
                    mdef.shift
                  end
                end
              end

              res = self.with_params(params).expand(mdef)
              case res
              when Hash
                if splat
                  raise "Unnecessary use of splat: #{entity.inspect}"
                end
                res.each_pair { |p| pairs << p }
              when Array
                if splat
                  if entity.size > 1
                    raise "Invalid array splat (needs to be single-pair hash): #{entity.inspect}"
                  end
                  return Splat.new(res)
                else
                  return res
                end
              else
                if splat
                  raise "Invalid macro expansion result for splat: #{res.inspect}"
                end
                return res
              end
            end
          else
            pairs << [k, expand(v)]
          end
        end

        pairs.to_h
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
      raise "Unspecified param {#{name}}" if res.nil?
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
