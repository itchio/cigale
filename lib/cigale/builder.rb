
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

  def builder_classes
    @builder_classes ||= {
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
        case b
        when "critical-block-start"
          xml.tag! "org.jvnet.hudson.plugins.exclusion.CriticalBlockStart", :plugin => "Exclusion"
          next
        when "critical-block-end"
          xml.tag! "org.jvnet.hudson.plugins.exclusion.CriticalBlockEnd", :plugin => "Exclusion"
          next
        when "github-notifier"
          xml.tag! "com.cloudbees.jenkins.GitHubSetCommitStatusBuilder"
          next
        end

        btype, bdef = first_pair(b)
        clazz = builder_classes[btype]

        unless clazz
          case btype
          when "managed-script"
            translate_managed_script_builder xml, bdef
          when "conditional-step"
            translate_conditional_step_builder xml, bdef
          when "shining-panda"
            translate_shining_panda_builder xml, bdef
          when "copyartifact"
            translate_copyartifact_builder xml, bdef
          when "config-file-provider"
            translate_config_file_provider_builder xml, bdef
          when "sonatype-clm"
            translate_sonatype_clm_builder xml, bdef
          else
            raise "Unknown builder type: #{btype}"
          end
        else
          xml.tag! clazz do
            self.send "translate_#{underize(btype)}_builder", xml, bdef
          end
        end
      end
    end
  end
end # Cigale::Builder
