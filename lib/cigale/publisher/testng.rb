module Cigale::Publisher
  def translate_testng_publisher (xml, pdef)
    xml.reportFilenamePattern pdef["pattern"]
    xml.escapeTestDescp pdef["escape-test-description"]
    xml.escapeExceptionMsg pdef["escape-exception-msg"]
  end
end
