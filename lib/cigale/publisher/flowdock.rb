module Cigale::Publisher
  def translate_flowdock_publisher (xml, pdef)
    xml.flowToken pdef["token"]
    xml.notificationTags pdef["tags"]
    xml.chatNotification boolp(pdef["chat-notification"], true)

    @flowdock_notifications ||= {
      "Success" => "SUCCESS",
      "Failure" => "FAILURE",
      "Fixed" => "FIXED",
      "Unstable" => "UNSTABLE",
      "Aborted" => "ABORTED",
      "NotBuilt" => "NOT_BUILT",
    }

    notifications = {
      "Success" => true,
      "Failure" => true,
      "Fixed" => true,
    }

    @flowdock_notifications.each do |k, v|
      setkey = "notify-#{k.downcase}"
      if pdef.has_key?(setkey)
        notifications[k] = pdef[setkey]
      end
    end

    xml.notifyMap do
      @flowdock_notifications.each do |k, v|
        xml.entry do
          xml.tag! "com.flowdock.jenkins.BuildResult", v
          xml.boolean !!notifications[k]
        end
      end
    end # notifymap

    @flowdock_notifications.each do |k, v|
      xml.tag! "notify#{k}", !!notifications[k]
    end
  end
end
