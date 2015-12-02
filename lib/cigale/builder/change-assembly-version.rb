
module Cigale::Builder::ChangeAssemblyVersion
  def translate_change_assembly_version_builder (xml, bdef)
    xml.task bdef["version"]
    xml.assemblyFile "AssemblyInfo.cs"
  end
end
