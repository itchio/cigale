
module Cigale::Builder

  def translate_copyartifact_builder (xml, bdef)
    bclass = case
    when bdef["projects"]
      "hudson.plugins.copyartifact.CopyArtifactPermissionProperty"
    else
      "hudson.plugins.copyartifact.CopyArtifact"
    end

    xml.tag! bclass do
      if projects = bdef["projects"]
        xml.projectNameList do
          for project in bdef["projects"]
            xml.string project
          end
        end
      else
        xml.project bdef["project"]
      end

      val = bdef["filter"] and xml.filter val
      val = bdef["target"] and xml.target val
      val = bdef["flatten"] and xml.flatten val
      val = bdef["optional"] and xml.optional val
      val = bdef["parameter-filters"] and xml.parameters val

      if buildnum = bdef["build-number"]
        xml.selector :class => "hudson.plugins.copyartifact.SpecificBuildSelector" do
          xml.buildNumber buildnum
        end
      end
    end
  end

end
