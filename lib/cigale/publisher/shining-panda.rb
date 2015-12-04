module Cigale::Publisher
  def translate_shining_panda_publisher (xml, pdef)
    xml.htmlDir pdef["html-reports-directory"]
  end
end
