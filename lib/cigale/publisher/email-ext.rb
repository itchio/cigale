module Cigale::Publisher
  def translate_email_ext_publisher (xml, pdef)
    xml.recipientList pdef["recipients"] || "$DEFAULT_RECIPIENTS"
    xml.configuredTriggers do
      @email_ext_triggers ||= {
        "always" => "Always",
        "unstable" => "Unstable",
        "first-failure" => "FirstFailure",
        "not-built" => "NotBuilt",
        "aborted" => "Aborted",
        "regression" => "Regression",
        "failure" => "Failure",
        "second-failure" => "SecondFailure",
        "improvement" => "Improvement",
        "still-failing" => "StillFailing",
        "success" => "Success",
        "fixed" => "Fixed",
        "still-unstable" => "StillUnstable",
        "pre-build" => "PreBuild",
      }

      sendto = {}
      for rec in (pdef["send-to"] || [])
        sendto[rec] = true
      end

      unless pdef.has_key?("failure")
        pdef["failure"] = true
      end

      @email_ext_triggers.each do |key, value|
        if pdef[key]
          xml.tag! "hudson.plugins.emailext.plugins.trigger.#{value}Trigger" do
            xml.email do
              xml.recipientList
              xml.subject "$PROJECT_DEFAULT_SUBJECT"
              xml.body "$PROJECT_DEFAULT_CONTENT"
              xml.sendToDevelopers boolp(sendto["developers"], false)
              xml.sendToRequester boolp(sendto["requester"], false)
              xml.includeCulprits boolp(sendto["culprits"], false)
              xml.sendToRecipientList boolp(sendto["recipients"], true)
            end
          end # trigger
        end
      end
    end # configuredTriggers

    xml.contentType case pdef["content-type"]
    when "html", nil
      "text/html"
    else
      raise "Unknown content-type: #{pdef["content-type"]}"
    end
    xml.defaultSubject pdef["subject"] || "Subject for Build ${BUILD_NUMBER}"
    xml.defaultContent pdef["content"] || "The build has finished"
    xml.attachmentsPattern pdef["attachments"]
    xml.presendScript pdef["presend-script"]
    xml.attachBuildLog boolp(pdef["attach-build-log"], false)
    xml.saveOutput boolp(pdef["save-output"], false)
    xml.disabled boolp(pdef["disabled"], false)
    xml.replyTo pdef["reply-to"] || "$DEFAULT_REPLYTO"
    xml.matrixTriggerMode case pdef["matrix-trigger"]
    when "only-configurations"
      "ONLY_CONFIGURATIONS"
    else
      raise "Unknown matrix trigger mode #{pdef["matrix-trigger"]}"
    end
  end
end
