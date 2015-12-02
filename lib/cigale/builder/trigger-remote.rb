
module Cigale::Builder

  def translate_trigger_remote_builder (xml, bdef)
    xml.remoteJenkinsName bdef["remote-jenkins-name"]
    xml.token bdef["token"]
    xml.job bdef["job"]
    dontFailBuild = if bdef.has_key?("should-fail-build")
      !bdef["should-fail-build"]
    else
      false
    end
    xml.shouldNotFailBuild dontFailBuild
    xml.pollInterval bdef["poll-interval"] || 10
    xml.connectionRetryLimit bdef["connection-retry-limit"] || 5
    xml.preventRemoteBuildQueue bdef["prevent-remote-build-queue"] || false
    xml.blockBuildUntilComplete bdef["block"] || true

    if preparams = bdef["predefined-parameters"]
      xml.parameters preparams
      xml.parameterList do
        for param in preparams.strip.split("\n")
          xml.string param
        end
      end
    end

    if propfile = bdef["property-file"]
      xml.loadParamsFromFile true
      xml.parameterFile propfile
    else
      xml.loadParamsFromFile false
    end
    xml.overrideAuth false
  end

end
