module Cigale::Publisher
  def translate_pipeline_publisher (xml, pdef)
    currpar = pdef["current-parameters"]
    predpar = pdef["predefined-parameters"]

    if currpar || predpar
      xml.configs do
        predpar and xml.tag! "hudson.plugins.parameterizedtrigger.PredefinedBuildParameters" do
          xml.properties predpar
        end
        currpar and xml.tag! "hudson.plugins.parameterizedtrigger.CurrentBuildParameters"
      end
    else
      xml.configs
    end

    xml.downstreamProjectName pdef["project"]
  end
end
