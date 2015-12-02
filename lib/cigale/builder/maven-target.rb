
module Cigale::Builder
  def translate_maven_target_builder (xml, bdef)
    xml.targets bdef["goals"]
    if props = bdef["properties"]
      xml.properties props.join("\n")
    else
      xml.properties
    end
    xml.mavenName bdef["maven-version"]
    if pom = bdef["pom"]
      xml.pom pom
    end

    privrepo = bdef["private-repository"]
    xml.usePrivateRepository !!privrepo

    if javaopts = bdef["java-opts"]
      xml.jvmOptions javaopts.join(" ")
    end

    if settings = bdef["settings"]
      if settings.start_with? "org.jenkinsci.plugins.configfiles.maven"
        xml.settings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnSettingsProvider" do
          xml.settingsConfigId settings
        end
      else
        xml.settings :class => "jenkins.mvn.FilePathSettingsProvider" do
          xml.path settings
        end
      end
    else
      xml.settings :class => "jenkins.mvn.DefaultSettingsProvider"
    end

    if gsettings = bdef["global-settings"]
      if gsettings.start_with? "org.jenkinsci.plugins.configfiles.maven"
        xml.globalSettings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnGlobalSettingsProvider" do
          xml.settingsConfigId gsettings
        end
      else
        xml.globalSettings :class => "jenkins.mvn.FilePathGlobalSettingsProvider" do
          xml.path gsettings
        end
      end
    else
      xml.globalSettings :class => "jenkins.mvn.DefaultGlobalSettingsProvider"
    end
  end
end
