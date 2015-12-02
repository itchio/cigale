
module Cigale::Builder

  def translate_artifact_resolver_builder (xml, bdef)
    xml.targetDirectory bdef["target-directory"]
    xml.artifacts do
      for artifact in bdef["artifacts"]
        xml.tag! "org.jvnet.hudson.plugins.repositoryconnector.Artifact" do
          xml.groupId artifact["group-id"]
          xml.artifactId artifact["group-id"]
          xml.classifier artifact["classifier"]
          xml.version artifact["version"]
          xml.extension artifact["extension"] || "jar"
          xml.targetFileName artifact["target-file-name"]
        end
      end
    end
    xml.failOnError bdef["fail-on-error"]
    xml.enableRepoLogging bdef["repository-logging"]
    xml.snapshotUpdatePolicy "never"
    xml.releaseUpdatePolicy "never"
    xml.snapshotChecksumPolicy "warn"
    xml.releaseChecksumPolicy "warn"
  end

end
