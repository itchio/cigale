
module Cigale::Wrapper
  def translate_custom_tools_wrapper (xml, wdef)
    xml.selectedTools do
      for tool in wdef["tools"]
        xml.tag! "com.cloudbees.jenkins.plugins.customtools.CustomToolInstallWrapper_-SelectedTool" do
          xml.name tool
        end
      end
    end

    xml.multiconfigOptions do
      xml.skipMasterInstallation wdef["skip-master-install"]
    end
    xml.convertHomesToUppercase wdef["convert-homes-to-upper"]
  end
end
