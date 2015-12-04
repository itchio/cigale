module Cigale::Publisher
  def translate_sloccount_publisher (xml, pdef)
    xml.pattern pdef["pattern"]
    xml.encoding pdef["encoding"]
  end
end
