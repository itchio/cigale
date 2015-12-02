
module Cigale::Builder
  def translate_change_assembly_version_builder (xml, bdef)
    xml.task bdef["version"]
    xml.assemblyFile bdef["assembly-file"] || "AssemblyInfo.cs"
  end
end
