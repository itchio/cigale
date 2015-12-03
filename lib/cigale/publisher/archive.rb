
module Cigale::Publisher
  def translate_archive_publisher (xml, pdef)
    xml.artifacts pdef["artifacts"]
    xml.latestOnly false
    xml.allowEmptyArchive pdef["allow-empty"]
    onlysucc = pdef["only-if-success"] and xml.onlyIfSuccessful onlysucc
    xml.fingerprint pdef["fingerprint"]
  end
end
