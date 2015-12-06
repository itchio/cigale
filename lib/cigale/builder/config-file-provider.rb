
module Cigale::Builder

  def translate_config_file_provider_builder (xml, bdef)
    xml.tag! "org.jenkinsci.plugins.configfiles.builder.ConfigFileBuildStep", :plugin => "config-file-provider" do
      xml.managedFiles do
        for file in toa bdef["files"]
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
