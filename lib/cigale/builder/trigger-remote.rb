
module Cigale::Builder

  def translate_trigger_remote_builder (xml, bdef)
    xml.remoteJenkinsName bdef["remote-jenkins-name"]
    xml.token bdef["token"]
    xml.job bdef["job"]
    xml.shouldNotFailBuild !bdef["should-fail-build"]
    xml.pollInterval bdef["poll-interval"]
    xml.connectionRetryLimit bdef["connection-retry-limit"]
    xml.preventRemoteBuildQueue bdef["prevent-remote-build-queue"]
    xml.blockBuildUntilComplete bdef["block"]
    xml.parameters bdef["predefined-parameters"]
    xml.parameterList do
      for param in bdef["predefined-parameters"].strip.split("\n")
        xml.string param
      end
    end
    xml.loadParamsFromFile true
    xml.parameterFile bdef["property-file"]
    xml.overrideAuth false
  end

end
