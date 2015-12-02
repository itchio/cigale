
module Cigale::Builder::MavenTarget
  def translate_maven_target_builder (xml, bdef)
    xml.targets bdef["goals"]
    xml.properties
    xml.mavenName bdef["maven-version"]
    xml.usePrivateRepository false

    xml.settings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnSettingsProvider" do
      xml.settingsConfigId bdef["settings"]
    end

    xml.globalSettings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnGlobalSettingsProvider" do
      xml.settingsConfigId bdef["global-settings"]
    end
  end
end
