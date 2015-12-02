
module Cigale::Builder

  def translate_inject_builder (xml, bdef)
    xml.info do
      val = bdef["properties-file"] and xml.propertiesFilePath val
      val = bdef["properties-content"] and xml.propertiesContent val
      val = bdef["script-file"] and xml.scriptFilePath val
      val = bdef["script-content"] and xml.scriptContent val
    end
  end

end
