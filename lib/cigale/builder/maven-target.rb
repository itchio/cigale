
module Cigale::Builder
  def translate_maven_target_builder (xml, bdef)
    xml.targets bdef["goals"]
    if props = bdef["properties"]
      xml.properties props.join(",")
    else
      xml.properties
    end
    xml.mavenName bdef["maven-version"]

    privrepo = bdef["private-repository"]
    xml.usePrivateRepository !!privrepo
    if settings = bdef["settings"]
      xml.settings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnSettingsProvider" do
        xml.settingsConfigId settings
      end
    else
      xml.settings :class => "jenkins.mvn.DefaultSettingsProvider"
    end

    if gsettings = bdef["global-settings"]
      xml.globalSettings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnGlobalSettingsProvider" do
        xml.settingsConfigId gsettings
      end
    else
      xml.globalSettings :class => "jenkins.mvn.DefaultGlobalSettingsProvider"
    end
  end
end
