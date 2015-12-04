module Cigale::Publisher
  def translate_sloccount_publisher (xml, pdef)
    xml.pattern pdef["report-files"]
    xml.encoding pdef["charset"]
  end
end
