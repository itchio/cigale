
module Cigale::Builder

  def translate_inject_builder (xml, bdef)
    xml.info do
      if val = bdef["properties-content"]
        xml.propertiesContent val
      end
    end
  end

end
