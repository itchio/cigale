module Cigale::Publisher
  def translate_javadoc_publisher (xml, pdef)
    xml.javadocDir pdef["directory"]
    xml.keepAll pdef["keep-all-successful"]
  end
end
