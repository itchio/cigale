module Cigale::Publisher
  def translate_shiningpanda_publisher (xml, pdef)
    xml.htmlDir pdef["html-reports-directory"]
  end
end
