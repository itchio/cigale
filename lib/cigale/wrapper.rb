
module Cigale::Wrapper
  require "cigale/wrapper/timeout"
  require "cigale/wrapper/config-file-provider"
  require "cigale/wrapper/inject-passwords"
  require "cigale/wrapper/delivery-pipeline"
  require "cigale/wrapper/port-allocator"
  require "cigale/wrapper/mongo-db"
  require "cigale/wrapper/rbenv"
  require "cigale/wrapper/m2-repository-cleanup"
  require "cigale/wrapper/logstash"
  require "cigale/wrapper/live-screenshot"
  require "cigale/wrapper/android-emulator"
  require "cigale/wrapper/ssh-agent-credentials"
  require "cigale/wrapper/logfilesize"
  require "cigale/wrapper/inject-ownership-variables"
  require "cigale/wrapper/inject"
  require "cigale/wrapper/env-script"
  require "cigale/wrapper/env-file"
  require "cigale/wrapper/exclusion"
  require "cigale/wrapper/matrix-tie-parent"
  require "cigale/wrapper/locks"
  require "cigale/wrapper/xvfb"
  require "cigale/wrapper/xvnc"
  require "cigale/wrapper/credentials-binding"
  require "cigale/wrapper/ci-skip"
  require "cigale/wrapper/job-log-logger"
  require "cigale/wrapper/custom-tools"
  require "cigale/wrapper/release"
  require "cigale/wrapper/ansi-color"
  require "cigale/wrapper/workspace-cleanup"

  class CustomWrapper
  end

  def wrapper_classes
    @wrapper_classes ||= {
      "mongo-db" => CustomWrapper.new,
      "rbenv" => CustomWrapper.new,
      "m2-repository-cleanup" => CustomWrapper.new,
      "logstash" => CustomWrapper.new,
      "logfilesize" => CustomWrapper.new,
      "exclusion" => CustomWrapper.new,
      "config-file-provider" => CustomWrapper.new,
      "ci-skip" => CustomWrapper.new,
      "delivery-pipeline" => CustomWrapper.new,
      "live-screenshot" => CustomWrapper.new,

      "timeout" => "hudson.plugins.build__timeout.BuildTimeoutWrapper",
      "inject-passwords" => "EnvInjectPasswordWrapper",
      "inject" => "EnvInject",
      "port-allocator" => "org.jvnet.hudson.plugins.port__allocator.PortAllocator",
      "android-emulator" => "hudson.plugins.android__emulator.AndroidEmulator",
      "ssh-agent-credentials" => "com.cloudbees.jenkins.plugins.sshagent.SSHAgentBuildWrapper",
      "inject-ownership-variables" => "com.synopsys.arc.jenkins.plugins.ownership.wrappers.OwnershipBuildWrapper",
      "inject" => "EnvInjectBuildWrapper",
      "env-script" => "com.lookout.jenkins.EnvironmentScript",
      "env-file" => "hudson.plugins.envfile.EnvFileBuildWrapper",
      "matrix-tie-parent" => "matrixtieparent.BuildWrapperMtp",
      "locks" => CustomWrapper.new,
      "xvfb" => "org.jenkinsci.plugins.xvfb.XvfbBuildWrapper",
      "xvnc" => "hudson.plugins.xvnc.Xvnc",
      "credentials-binding" => "org.jenkinsci.plugins.credentialsbinding.impl.SecretBuildWrapper",
      "job-log-logger" => "org.jenkins.ci.plugins.jobloglogger.JobLogLoggerBuildWrapper",
      "custom-tools" => "com.cloudbees.jenkins.plugins.customtools.CustomToolInstallWrapper",
      "release" => "hudson.plugins.release.ReleaseWrapper",
      "ansi-color" => ["hudson.plugins.ansicolor.AnsiColorBuildWrapper", :plugin => "ansicolor@0.4.2"],
      "workspace-cleanup" => ["hudson.plugins.ws__cleanup.PreBuildCleanup", :plugin => "ws-cleanup@0.28"],
    }
  end

  def translate_wrappers (xml, wrappers)
    wrappers = toa wrappers
    wrappers = toa(wrappers).reject do |w|
      type, spec = asplode w
      case
      when type == "locks" && (toa spec).empty?
        true
      else
        false
      end
    end

    if wrappers.empty?
      return xml.buildWrappers
    end

    xml.buildWrappers do
      for w in wrappers
        type, spec = asplode w
        translate("wrapper", xml, type, spec)
      end
    end
  end # translate_wrappers

end # Cigale::Wrapper
