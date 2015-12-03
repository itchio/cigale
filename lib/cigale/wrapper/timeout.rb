
module Cigale::Wrapper
  def translate_timeout_wrapper (xml, wdef)
    use_strategy = wdef.has_key?("timeout") && %w(no-activity likely-stuck absolute).include?(wdef["type"])

    xml.timeoutMinutes wdef["timeout"] || 3

    timeoutvar = wdef["timeout-var"] and xml.timeoutEnvVar timeoutvar
    xml.failBuild wdef["fail"]
    xml.writingDescription boolp(wdef["write-description"], false)

    xml.timeoutPercentage wdef["elastic-percentage"] || 0
    xml.timeoutMinutesElasticDefault wdef["elastic-default-timeout"] || 3

    case wdef["type"]
    when "absolute"
      xml.timeoutType "absolute"
    when "elastic"
      xml.timeoutType "elastic"
    when "likely-stuck"
      xml.timeoutType "likelyStuck"
    end
  end
end
