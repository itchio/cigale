
module Cigale::Property
  def translate_least_load_property (xml, pdef)
    xml.leastLoadDisabled pdef["disabled"]
  end
end
