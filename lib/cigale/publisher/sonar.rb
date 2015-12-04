module Cigale::Publisher
  def translate_sonar_publisher (xml, pdef)
    xml.jdk pdef["jdk"]
    xml.branch pdef["branch"]
    xml.language pdef["language"]
    xml.rootPom pdef["root-pom"] || "pom.xml"
    xml.usePrivateRepository boolp(pdef["private-maven-repo"], false)
    xml.mavenOpts pdef["maven-opts"]
    xml.jobAdditionalProperties pdef["additional-properties"]

    skips = pdef["skip-global-triggers"]
    xml.triggers do
      xml.skipScmCause skips["skip-when-scm-change"]
      xml.skipUpstreamCause skips["skip-when-upstream-build"]
      xml.envVar skips["skip-when-envvar-defined"]
    end

    if set = pdef["settings"]
      xml.settings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnSettingsProvider" do
        xml.settingsConfigId set
      end
    else
      xml.settings :class => "jenkins.mvn.DefaultSettingsProvider"
    end

    if gset = pdef["global-settings"]
      xml.globalSettings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnGlobalSettingsProvider" do
        xml.settingsConfigId set
      end
    else
      xml.globalSettings :class => "jenkins.mvn.DefaultGlobalSettingsProvider"
    end
  end
end
