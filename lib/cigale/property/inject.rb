
module Cigale::Property
  def translate_inject_property (xml, pdef)
    xml.info do
      if props = pdef["properties-content"]
        xml.propertiesContent props
      end
      xml.loadFilesFromMaster false
    end
    xml.on true
    xml.keepJenkinsSystemVariables boolp(pdef["keep-system-variables"], true)
    xml.keepBuildVariables boolp(pdef["keep-build-variables"], true)
    xml.overrideBuildParameters boolp(pdef["override-build-parameters"], false)
  end
end
