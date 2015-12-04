module Cigale::Publisher
  def translate_testng_publisher (xml, pdef)
    reportFilenamePattern pdef["pattern"]
    escapeTestDescp pdef["escape-text-description"]
    escapeExceptionMsg pdef["escape-exception-msg"]
  end
end
