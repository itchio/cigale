
module Cigale::Publisher
  # require "cigale/publisher/xxx"

  class CustomPublisher
  end

  def publisher_classes
    @publisher_classes ||= {
      "" => "",
    }
  end

  def translate_publishers (xml, tag, publishers)
    if (publishers || []).size == 0
      return xml.tag! tag
    end

    xml.tag! tag do
      for p in publishers
        ptype, pdef = lookup_publisher(p)
        case ptype
        when "raw"
          for l in pdef["xml"].split("\n")
            xml.indent!
            xml << l + "\n"
          end
        else
          method = "translate_#{underize(ptype)}_builder"
          clazz = publisher_classes[ptype]
          raise "Unknown publisher type: #{ptype}" unless clazz

          case clazz
          when CustomPublisher
            self.send method, xml, pdef
          else
            xml.tag! clazz do
              self.send method, xml, pdef
            end
          end
        end # not raw
      end # for p in publishers
    end
  end # translate_publishers

  def lookup_publisher (p)
    ptype = nil
    pdef = {}

    case p
    when Hash
      ptype, pdef = first_pair(p)
    when String
      raise "Invalid publisher markup: #{p.inspect}"
    end

    return ptype, pdef
  end
end
