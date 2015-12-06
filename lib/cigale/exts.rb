
require "pp" # pretty-print

module Cigale
  class Exts
    # Lets you do `dig(hash, "a.b.c")` instead of `hash["a"]["b"]["c"]`
    def dig(h, dotted_path)
      parts = dotted_path.split '.', 2
      match = h[parts[0]]
      if !parts[1] or match.nil?
        return match
      else
        return dig(match, parts[1])
      end
    end

    # Given {:a => b, :c => d, :e => f}, returns [:a, b]
    def first_pair(h)
      h.each_pair.next
    end

    # Given `{"a" => "b"}`, returns ["a", "b"].
    # Given `"a"`, returns ["a", {}]
    def asplode(node)
      type = nil
      spec = {}

      case node
      when Hash
        type, spec = first_pair(node)
      when String
        type = node
      else
        raise "Invalid markup: #{b.inspect}"
      end

      return type, spec
    end

    # Make sure something is an array
    def toa (input)
      case input
      when Array
        return input
      when nil
        return []
      else
        return [input]
      end
    end

    # Make sure something is a hash
    def toh (input)
      case input
      when Hash
        return input
      when nil
        return {}
      else
        raise "Can't toh {input.inspect}"
      end
    end

    # Give a default to a boolean parameter
    # (val || default) doesn't work because val
    # may be false instead of nil
    def boolp (val, default)
      if val.nil?
        default
      else
        val
      end
    end
  end
end

require "builder/xmlbase"

module Builder
  class XmlBase
    # expose private method '_indent' for our 'raw' implementation
    def indent!
      _indent
    end
  end
end
