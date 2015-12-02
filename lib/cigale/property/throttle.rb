
module Cigale::Property
  def translate_throttle_property (xml, pdef)
    xml.maxConcurrentPerNode 0
    xml.maxConcurrentTotal pdef["max-total"]
    xml.throttleEnabled true
    xml.categories do
      for cat in pdef["categories"]
        xml.string cat
      end
    end
    xml.throttleOption
    xml.configVersion 1
  end
end
