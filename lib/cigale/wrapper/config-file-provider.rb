
module Cigale::Wrapper
  def translate_config_file_provider_wrapper (xml, wdef)
    xml.tag! "org.jenkinsci.plugins.configfiles.buildwrapper.ConfigFileBuildWrapper", :plugin => "config-file-provider" do
      xml.managedFiles do
        for file in wdef["files"]
          xml.tag! "org.jenkinsci.plugins.configfiles.buildwrapper.ManagedFile" do
            xml.fileId file["file-id"]
            xml.targetLocation file["target"]
            xml.variable file["variable"]
          end
        end
      end
    end
  end
end
