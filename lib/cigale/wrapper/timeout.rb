
module Cigale::Wrapper
  def translate_timeout_wrapper (xml, wdef)
    use_strategy = wdef.has_key?("timeout") && %w(no-activity likely-stuck absolute).include?(wdef["type"])

    if use_strategy
      case wdef["type"]
      when "no-activity"
        xml.strategy :class => "hudson.plugins.build_timeout.impl.NoActivityTimeOutStrategy" do
          xml.timeoutSecondsString wdef["timeout"] * 60
        end
      when "likely-stuck"
        xml.strategy :class => "hudson.plugins.build_timeout.impl.LikelyStuckTimeOutStrategy" do
          xml.timeoutMinutes wdef["timeout"]
        end
      when "absolute"
        xml.strategy :class => "hudson.plugins.build_timeout.impl.AbsoluteTimeOutStrategy" do
          xml.timeoutMinutes wdef["timeout"]
        end
      end
    else
      xml.timeoutMinutes wdef["timeout"] || 3
    end

    writedesc = wdef["write-description"]
    abort = boolp(wdef["abort"], true)
    writeops = (writedesc || abort) && use_strategy

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

    if timeoutvar = wdef["timeout-var"]
      xml.timeoutEnvVar timeoutvar
    end

    if wdef.has_key?("fail")
      xml.failBuild wdef["fail"]
    end

    if !use_strategy
      unless writedesc
        xml.writingDescription false
      end

      case wdef["type"]
      when "no-activity"
        # muffin
      else
        xml.timeoutPercentage 0
        xml.timeoutMinutesElasticDefault 3
        case wdef["type"]
        when "likely-stuck"
          xml.timeoutType "likelyStuck"
        end
      end
    end
  end
end
