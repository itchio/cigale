
module Cigale::Wrapper
  def translate_delivery_pipeline_wrapper (xml, wdef)
    xml.versionTemplate wdef["version-template"]
    xml.updateDisplayName wdef["set-display-name"]
  end
end
