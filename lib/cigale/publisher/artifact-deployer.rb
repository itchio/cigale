
module Cigale::Publisher
  def translate_artifact_deployer_publisher (xml, pdef)
    xml.entries do
      for entry in pdef["entries"]
        xml.tag! "org.jenkinsci.plugins.artifactdeployer.ArtifactDeployerEntry" do
          xml.includes entry["files"]
          xml.basedir entry["basedir"]
          xml.excludes entry["excludes"]
          xml.remote entry["remote"]
          xml.flatten entry["flatten"]
          xml.deleteRemote entry["delete-remote"]
          xml.deleteRemoteArtifacts entry["delete-remote-artifacts"]
          xml.failNoFilesDeploy entry["fail-no-files"]
          xml.groovyExpression entry["groovy-script"]
        end
      end
    end
    xml.deployEvenBuildFail pdef["deploy-if-fail"]
  end
end
