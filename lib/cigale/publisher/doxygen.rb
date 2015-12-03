module Cigale::Publisher
  def translate_doxygen_publisher (xml, pdef)
    xml.doxyfilePath pdef["doxyfile"]
    xml.keepAll pdef["keepall"]
    xml.folderWhereYouRunDoxygen pdef["folder"]
  end
end
