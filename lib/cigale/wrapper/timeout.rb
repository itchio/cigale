
module Cigale::Wrapper
  def translate_timeout_wrapper (xml, wdef)
    case wdef["type"]
    when "no-activity"
      xml.strategy :class => "hudson.plugins.build_timeout.impl.NoActivityTimeOutStrategy" do
        xml.timeoutSecondsString wdef["timeout"] * 60
      end
    else
      xml.timeoutMinutes wdef["timeout"]
    end

    writedesc = wdef["write-description"]
    abort = wdef["abort"]
    writeops = writedesc || abort

    if writeops
      xml.operationList do
        if abort
          xml.tag! "hudson.plugins.build__timeout.operations.AbortOperation"
        end

        if writedesc
          xml.tag! "hudson.plugins.build__timeout.operations.WriteDescriptionOperation" do
            xml.description writedesc
          end
        end
      end
    end

    xml.timeoutEnvVar wdef["timeout-var"]

    fail = wdef["fail"] and xml.failBuild fail
    unless writedesc
      xml.writingDescription false
    end

    case wdef["type"]
    when "no-activity"
      # muffin
    else
      xml.timeoutPercentage 0
      xml.timeoutMinutesElasticDefault 3
      xml.timeoutType wdef["type"]
    end
  end
end
