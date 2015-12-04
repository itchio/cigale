module Cigale::Publisher
  def translate_logparser_publisher (xml, pdef)
    xml.unstableOnWarning pdef["unstable-on-warning"]
    xml.failBuildOnError pdef["fail-on-error"]
    xml.parsingRulesPath pdef["parse-rules"]
  end
end
