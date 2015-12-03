
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

  def wrapper_classes
    @wrapper_classes ||= {
      "timeout" => "hudson.plugins.build__timeout.BuildTimeoutWrapper",
      "inject-passwords" => "EnvInjectPasswordWrapper",
      "port-allocator" => "org.jvnet.hudson.plugins.port__allocator.PortAllocator",
      "android-emulator" => "hudson.plugins.android__emulator.AndroidEmulator",
      "ssh-agent-credentials" => "com.cloudbees.jenkins.plugins.sshagent.SSHAgentBuildWrapper",
      "inject-ownership-variables" => "com.synopsys.arc.jenkins.plugins.ownership.wrappers.OwnershipBuildWrapper",
      "env-script" => "com.lookout.jenkins.EnvironmentScript",
      "env-file" => "hudson.plugins.envfile.EnvFileBuildWrapper",
      "matrix-tie-parent" => "matrixtieparent.BuildWrapperMtp",
    }
  end

  def translate_wrappers (xml, wrappers)
    if (wrappers || []).size == 0
      return xml.buildWrappers
    end

    xml.buildWrappers do
      for w in wrappers
        case w
        when "rbenv"
          translate_rbenv_wrapper xml, {}
          next
        when "m2-repository-cleanup"
          translate_m2_repository_cleanup_wrapper xml, {}
          next
        when "live-screenshot"
          translate_live_screenshot_wrapper xml, {}
          next
        when "logfilesize"
          translate_logfilesize_wrapper xml, {}
          next
        when "delivery-pipeline"
          translate_delivery_pipeline_wrapper xml, {}
          next
        end

        wtype, wdef = first_pair(w)
        clazz = wrapper_classes[wtype]

        if clazz
          xml.tag! clazz do
            self.send "translate_#{underize(wtype)}_wrapper", xml, wdef
          end
        else
          case wtype
          when "raw"
            for l in wdef["xml"].split("\n")
              xml.indent!
              xml << l + "\n"
            end
          when "config-file-provider"
            translate_config_file_provider_wrapper xml, wdef
          when "mongo-db"
            translate_mongo_db_wrapper xml, wdef
          when "rbenv"
            translate_rbenv_wrapper xml, wdef
          when "m2-repository-cleanup"
            translate_m2_repository_cleanup_wrapper xml, wdef
          when "logstash"
            translate_logstash_wrapper xml, wdef
          when "live-screenshot"
            translate_live_screenshot_wrapper xml, wdef
          when "logfilesize"
            translate_logfilesize_wrapper xml, wdef
          when "exclusion"
            translate_exclusion_wrapper xml, wdef
          when "delivery-pipeline"
            translate_delivery_pipeline_wrapper xml, wdef
          else
            raise "Unknown wrapper type: #{wtype}"
          end
        end # unless clazz

      end # for w in wrappers
    end # wrappers
  end
end
