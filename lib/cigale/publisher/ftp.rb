module Cigale::Publisher
  def translate_ftp_publisher (xml, pdef)
    xml.consolePrefix "FTP: "
    xml.delegate do
      xml.publishers do
        xml.tag! "jenkins.plugins.publish__over__ftp.BapFtpPublisher" do
          xml.configName pdef["site"]
          xml.verbose true
          xml.transfers do
            xml.tag! "jenkins.plugins.publish__over__ftp.BapFtpTransfer" do
              xml.remoteDirectory pdef["target"]
              xml.sourceFiles pdef["source"]
              xml.excludes pdef["excludes"]
              xml.removePrefix pdef["remove-prefix"]
              xml.remoteDirectorySDF false
              xml.flatten pdef["flatten"]
              xml.cleanRemote false
              xml.asciiMode false
            end
          end

          xml.useWorkspaceInPromotion false
          xml.usePromotionTimestamp false
        end
      end # publishers

      xml.continueOnError false
      xml.failOnError false
      xml.alwaysPublishFromMaster false
      xml.hostConfigurationAccess :class => "jenkins.plugins.publish_over_ftp.BapFtpPublisherPlugin", :reference => "../.."
    end
  end
end
