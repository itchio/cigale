
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
  end
end
