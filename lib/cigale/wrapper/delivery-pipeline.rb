
module Cigale::Wrapper
  def translate_delivery_pipeline_wrapper (xml, wdef)
    xml.tag! "se.diabol.jenkins.pipeline.PipelineVersionContributor" do
      xml.versionTemplate wdef["version-template"]
      xml.updateDisplayName boolp(wdef["set-display-name"], false)
    end
  end
end
