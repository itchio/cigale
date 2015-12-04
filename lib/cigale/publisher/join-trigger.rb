module Cigale::Publisher
  def translate_join_trigger_publisher (xml, pdef)
    xml.joinProjects pdef["projects"].join(",")
    xml.joinPublishers do
      xml.tag! "hudson.plugins.parameterizedtrigger.BuildTrigger" do
        xml.configs do
          for pub in pdef["publishers"]
            xml.tag! "hudson.plugins.parameterizedtrigger.BuildTriggerConfig" do
              xml.configs do
                if pub["current-parameters"]
                  xml.tag! "hudson.plugins.parameterizedtrigger.CurrentBuildParameters"
                end
              end

              xml.projects pub["project"]
              xml.condition "ALWAYS"
              xml.triggerWithNoParameters pub["trigger-with-no-params"]
            end
          end # for pub in publishers
        end # xml.configs
      end # BuildTrigger
    end # xml.joinPublishers

    xml.evenIfDownstreamUnstable pdef["even-if-unstable"]
  end
end
