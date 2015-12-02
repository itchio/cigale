
module Cigale::Builder

  def translate_ant_builder (xml, bdef)
    xml.targets bdef
    xml.antName "default"
  end

end
