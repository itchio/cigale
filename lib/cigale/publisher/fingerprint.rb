module Cigale::Publisher
  def translate_fingerprint_publisher (xml, pdef)
    xml.targets pdef["files"]
    xml.recordBuildArtifacts pdef["record-artifacts"]
  end
end
