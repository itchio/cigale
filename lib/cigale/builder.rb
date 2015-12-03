
module Cigale::Builder
  require "cigale/builder/build_status"
  require "cigale/builder/conditional"
  require "cigale/builder/inject"
  require "cigale/builder/shell"
  require "cigale/builder/batch"
  require "cigale/builder/gradle"
  require "cigale/builder/managed-script"
  require "cigale/builder/trigger-builds"
  require "cigale/builder/trigger-remote"
  require "cigale/builder/ssh"
  require "cigale/builder/maven-target"
  require "cigale/builder/maven-builder"
  require "cigale/builder/sonar"
  require "cigale/builder/shining-panda"
  require "cigale/builder/powershell"
  require "cigale/builder/python"
  require "cigale/builder/msbuild"
  require "cigale/builder/builders-from"
  require "cigale/builder/grails"
  require "cigale/builder/system-groovy"
  require "cigale/builder/groovy"
  require "cigale/builder/change-assembly-version"
  require "cigale/builder/beaker"
  require "cigale/builder/copyartifact"
  require "cigale/builder/artifact-resolver"
  require "cigale/builder/multijob"
  require "cigale/builder/cmake"
  require "cigale/builder/ant"
  require "cigale/builder/sbt"
  require "cigale/builder/dsl"
  require "cigale/builder/config-file-provider"
  require "cigale/builder/sonatype-clm"
  require "cigale/builder/exclusion"
  require "cigale/builder/github-notifier"

  class CustomBuilder
  end

  def builder_classes
    @builder_classes ||= {
      "critical-block-start" => CustomBuilder.new,
      "critical-block-end" => CustomBuilder.new,
      "github-notifier" => CustomBuilder.new,
      "managed-script" => CustomBuilder.new,
      "conditional-step" => CustomBuilder.new,
      "shining-panda" => CustomBuilder.new,
      "copyartifact" => CustomBuilder.new,
      "config-file-provider" => CustomBuilder.new,
      "sonatype-clm" => CustomBuilder.new,

      "inject" => "EnvInjectBuilder",
      "shell" => "hudson.tasks.Shell",
      "batch" => "hudson.tasks.BatchFile",
      "gradle" => "hudson.plugins.gradle.Gradle",
      "trigger-builds" => "hudson.plugins.parameterizedtrigger.TriggerBuilder",
      "trigger-remote" => "org.jenkinsci.plugins.ParameterizedRemoteTrigger.RemoteBuildConfiguration",
      "ssh-builder" => "org.jvnet.hudson.plugins.SSHBuilder",
      "maven-target" => "hudson.tasks.Maven",
      "maven-builder" => "org.jfrog.hudson.maven3.Maven3Builder",
      "sonar" => "hudson.plugins.sonar.SonarRunnerBuilder",
      "powershell" => "hudson.plugins.powershell.PowerShell",
      "python" => "hudson.plugins.python.Python",
      "msbuild" => "hudson.plugins.msbuild.MsBuildBuilder",
      "builders-from" => "hudson.plugins.templateproject.ProxyBuilder",
      "grails" => "com.g2one.hudson.grails.GrailsBuilder",
      "system-groovy" => "hudson.plugins.groovy.SystemGroovy",
      "groovy" => "hudson.plugins.groovy.Groovy",
      "change-assembly-version" => "org.jenkinsci.plugins.changeassemblyversion.ChangeAssemblyVersion",
      "beaker" => "org.jenkinsci.plugins.beakerbuilder.BeakerBuilder",
      "multijob" => "com.tikal.jenkins.plugins.multijob.MultiJobBuilder",
      "cmake" => "hudson.plugins.cmake.CmakeBuilder",
      "ant" => "hudson.tasks.Ant",
      "sbt" => "org.jvnet.hudson.plugins.SbtPluginBuilder",
      "dsl" => "javaposse.jobdsl.plugin.ExecuteDslScripts",
      "artifact-resolver" => "org.jvnet.hudson.plugins.repositoryconnector.ArtifactResolver",
    }
  end

  def translate_builders (xml, tag, builders)
    if (builders || []).size == 0
      return xml.builders
    end

    xml.tag! tag do
      for b in builders
        btype, bdef = lookup_builder(b)
        case btype
        when "raw"
          for l in bdef["xml"].split("\n")
            xml.indent!
            xml << l + "\n"
          end
        else
          method = "translate_#{underize(btype)}_builder"
          clazz = builder_classes[btype]
          raise "Unknown builder type: #{btype}" unless clazz

          case clazz
          when CustomBuilder
            self.send method, xml, bdef
          else
            xml.tag! clazz do
              self.send method, xml, bdef
            end
          end
        end # not raw
      end # for b in builders
    end
  end

  def lookup_builder (w)
    btype = nil
    bdef = {}
    clazz = nil

    case w
    when Hash
      btype, bdef = first_pair(w)
    when String
      btype = w
    else
      raise "Invalid builder markup: #{w.inspect}"
    end

    return btype, bdef
  end

end # Cigale::Builder
