module Cigale::Publisher
  def translate_ssh_publisher (xml, pdef)
    xml.consolePrefix "SSH: "

    xml.delegate do
      xml.publishers do
        xml.tag! "jenkins.plugins.publish__over__ssh.BapSshPublisher" do
          xml.configName pdef["site"]
          xml.verbose true
          xml.transfers do
            xml.tag! "jenkins.plugins.publish__over__ssh.BapSshTransfer" do
              xml.remoteDirectory pdef["target"]
              xml.sourceFiles pdef["source"]
              xml.execCommand pdef["command"]
              xml.execTimeout pdef["timeout"]
              xml.usePty pdef["use-pty"]
              xml.excludes pdef["excludes"]
              xml.removePrefix pdef["remove-prefix"]
              xml.remoteDirectorySDF false
              xml.flatten pdef["flatten"]
              xml.cleanRemote false
            end # BapSshTransfer
          end # transfers

          xml.useWorkspaceInPromotion false
          xml.usePromotionTimestamp false
        end # BapSshPublisher
      end # publishers

      xml.continueOnError false
      xml.failOnError false
      xml.alwaysPublishFromMaster false
      xml.hostConfigurationAccess :class => "jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin", :reference => "../.."
    end # delegate
  end # translate
end
