module Cigale::Publisher
  def translate_cifs_publisher (xml, pdef)
    xml.consolePrefix "CIFS: "
    xml.delegate do
      xml.publishers do
        xml.tag! "jenkins.plugins.publish__over__cifs.CifsPublisher" do
          xml.configName pdef["site"]
          xml.verbose true
          xml.transfers do
            xml.tag! "jenkins.plugins.publish__over__cifs.CifsTransfer" do
              xml.remoteDirectory pdef["target"]
              xml.sourceFiles pdef["source"]
              xml.excludes pdef["excludes"]
              xml.removePrefix pdef["remove-prefix"]
              xml.remoteDirectorySDF false
              xml.flatten pdef["flatten"]
              xml.cleanRemote false
            end # CifsTransfer
          end #transfers

          xml.useWorkspaceInPromotion false
          xml.usePromotionTimestamp false
        end # CifsPublisher
      end # publishers

      xml.continueOnError false
      xml.failOnError false
      xml.alwaysPublishFromMaster false
      xml.hostConfigurationAccess :class => "jenkins.plugins.publish_over_cifs.CifsPublisherPlugin", :reference => "../.."
    end # delegate
  end # translate
end
