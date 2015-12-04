module Cigale::Publisher
  def translate_ircbot_publisher (xml, pdef)
    xml.buildToChatNotifier :class => "hudson.plugins.im.build_notify.DefaultBuildToChatNotifier"
    xml.strategy (pdef["strategy"] || "all").upcase
    xml.targets do
      for chan in pdef["channels"]
        xml.tag! "hudson.plugins.im.GroupChatIMMessageTarget" do
          xml.name chan["name"]
          xml.password chan["password"]
          xml.notificationOnly chan["notify-only"]
        end
      end
    end

    xml.notifyOnBuildStart boolp(pdef["notify-start"], false)
    xml.notifySuspects boolp(pdef["notify-committers"], false)
    xml.notifyCulprits boolp(pdef["notify-culprits"], false)
    xml.notifyFixers boolp(pdef["notify-fixers"], false)
    xml.notifyUpstreamCommitters boolp(pdef["notify-upstream"], false)
    xml.matrixMultiplier (pdef["matrix-notifier"] || "only-configurations").gsub("-", "_").upcase
  end
end
