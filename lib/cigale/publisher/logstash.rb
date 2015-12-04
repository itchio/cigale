module Cigale::Publisher
  def translate_logstash_publisher (xml, pdef)
    xml.maxLines pdef["max-lines"] || 1000
    xml.failBuild boolp(pdef["fail-build"], false)
  end
end
