
# FIXME Don't monkey-path stuff
class Hash
  # Lets you do `hash.dig("a.b.c")` instead of `hash["a"]["b"]["c"]`
  def dig(dotted_path)
    parts = dotted_path.split '.', 2
    match = self[parts[0]]
    if !parts[1] or match.nil?
      return match
    else
      return match.dig(parts[1])
    end
  end
end
