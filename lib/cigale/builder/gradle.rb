
module Cigale::Builder::Gradle
  def translate_gradle_builder (xml, bdef)
    xml.description
    xml.tasks bdef["tasks"]
    xml.buildFile
    xml.rootBuildScriptDir bdef["root-build-script-dir"]
    xml.gradleName bdef["gradle-name"]
    xml.useWrapper bdef["wrapper"]
    xml.makeExecutable bdef["executable"]
    xml.switches bdef["switches"].join("\n")
    xml.fromRootBuildScriptDir (not bdef["root-build-script-dir"].nil?)
  end
end
