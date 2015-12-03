
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
  require "cigale/wrapper/env-script"
  require "cigale/wrapper/env-file"
  require "cigale/wrapper/exclusion"
  require "cigale/wrapper/matrix-tie-parent"
  require "cigale/wrapper/locks"
  require "cigale/wrapper/xvfb"

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
      "exclusion" => CustomWrapper.new,

      "timeout" => "hudson.plugins.build__timeout.BuildTimeoutWrapper",
      "inject-passwords" => "EnvInjectPasswordWrapper",
      "port-allocator" => "org.jvnet.hudson.plugins.port__allocator.PortAllocator",
      "android-emulator" => "hudson.plugins.android__emulator.AndroidEmulator",
      "ssh-agent-credentials" => "com.cloudbees.jenkins.plugins.sshagent.SSHAgentBuildWrapper",
      "inject-ownership-variables" => "com.synopsys.arc.jenkins.plugins.ownership.wrappers.OwnershipBuildWrapper",
      "env-script" => "com.lookout.jenkins.EnvironmentScript",
      "env-file" => "hudson.plugins.envfile.EnvFileBuildWrapper",
      "matrix-tie-parent" => "matrixtieparent.BuildWrapperMtp",
      "locks" => "hudson.plugins.locksandlatches.LockWrapper",
      "xvfb" => "org.jenkinsci.plugins.xvfb.XvfbBuildWrapper"
    }
  end

  def translate_wrappers (xml, wrappers)
    wrappers = (wrappers || []).reject do |wrapper|
      case wrapper
      when Hash
        k, v = first_pair(wrapper)
        true if k == "locks" && (v || []).empty?
      else
        false
      end
    end

    if (wrappers || []).size == 0
      return xml.buildWrappers
    end

    xml.buildWrappers do
      for w in wrappers
        wtype, wdef = lookup_wrapper(w)
        case wtype
        when "raw"
          for l in wdef["xml"].split("\n")
            xml.indent!
            xml << l + "\n"
          end
        else
          method = "translate_#{underize(wtype)}_wrapper"
          clazz = wrapper_classes[wtype]
          raise "Unknown wrapper type: #{wtype}" unless clazz

          case clazz
          when CustomWrapper
            self.send method, xml, wdef
          else
            xml.tag! clazz do
              self.send method, xml, wdef
            end
          end
        end
      end # for w in wrappers
    end # xml.buildWrappers
  end

  def lookup_wrapper (w)
    wtype = nil
    wdef = {}
    clazz = nil

    case w
    when Hash
      wtype, wdef = first_pair(w)
    when String
      wtype = w
    else
      raise "Invalid wrapper markup: #{w.inspect}"
    end

    return wtype, wdef
  end

end
