module Cigale::Publisher
  def translate_jabber_publisher (xml, pdef)
    xml.targets do
      for gt in (pdef["group-targets"] || [])
        xml.tag! "hudson.plugins.im.GroupChatIMMessageTarget" do
          xml.name gt
          xml.notificationOnly false
        end
      end

      for it in (pdef["individual-targets"] || [])
        xml.tag! "hudson.plugins.im.DefaultIMMessageTarget" do
          xml.value it
        end
      end
    end

    xml.strategy (pdef["strategy"] || "all").upcase
    xml.notifyOnBuildStart pdef["notify-on-build-start"]
    xml.notifySuspects false
    xml.notifyCulprits false
    xml.notifyFixers false
    xml.notifyUpstreamCommitters false
    xml.buildToChatNotifier :class => "hudson.plugins.im.build_notify.DefaultBuildToChatNotifier"
    xml.matrixMultiplier "ONLY_CONFIGURATIONS"
  end # xml.targets
end
