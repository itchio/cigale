
module Cigale::Builder
  def translate_managed_script_builder (xml, bdef)
    sclass = case bdef["type"]
    when "script"
      "org.jenkinsci.plugins.managedscripts.ScriptBuildStep"
    when "batch"
      "org.jenkinsci.plugins.managedscripts.WinBatchBuildStep"
    else
      raise "Unknown managed script type: #{bdef["type"]}"
    end

    xml.tag! sclass do
      case bdef["type"]
      when "script"
        xml.buildStepId bdef["script-id"]
      when "batch"
        xml.command bdef["script-id"]
      end
      xml.buildStepArgs do
        for arg in bdef["args"]
          xml.string arg
        end
      end
    end
  end
end
