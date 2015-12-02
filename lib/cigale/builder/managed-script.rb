
module Cigale::Builder::ManagedScript
  def translate_managed_script_builder (xml, bdef)
    sclass = case bdef["type"]
    when "script"
      "org.jenkinsci.plugins.managedscripts.ScriptBuildStep"
    else
      raise "Unknown managed script type: #{bdef["type"]}"
    end

    xml.tag! sclass do
      xml.buildStepId bdef["script-id"]
      xml.buildStepArgs do
        for arg in bdef["args"]
          xml.string arg
        end
      end
    end
  end
end
