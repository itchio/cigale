
module Cigale::Property
  def translate_copyartifact_property (xml, pdef)
    xml.tag! "hudson.plugins.copyartifact.CopyArtifactPermissionProperty", :plugin => "copyartifact" do
      xml.projectNameList do
        xml.string pdef["projects"]
      end
    end
  end
end
