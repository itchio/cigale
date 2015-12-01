
require "pp" # pretty-print

module Cigale
  class Exts
    @@debug = false

    def self.debug= (debug)
      @@debug = debug
    end

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

    def mutt (msg, obj)
      return unless @@debug

      puts "--------------------"
      puts "> #{msg}: "
      puts
      pp obj
      puts "--------------------"
    end

    def matt
      return unless @@debug
      
      puts
      puts "==============================="
      puts
    end
  end
end
