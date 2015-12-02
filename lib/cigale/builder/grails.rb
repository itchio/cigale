
module Cigale::Builder::Grails
  def translate_grails_builder (xml, bdef)
    xml.targets bdef["targets"]
    xml.name bdef["name"]
    xml.grailsWorkDir bdef["work-dir"]
    xml.projectWorkDir bdef["project-dir"]
    xml.projectBaseDir bdef["base-dir"]
    xml.serverPort bdef["server-port"]
    xml.properties bdef["properties"]
    xml.forceUpgrade bdef["force-upgrade"]
    xml.nonInteractive bdef["non-interactive"]
    xml.useWrapper bdef["use-wrapper"]
    xml.plainOutput bdef["plain-output"]
    xml.stackTrace bdef["stack-trace"]
    xml.verbose bdef["verbose"]
    xml.refreshDependencies bdef["refresh-dependencies"]
  end
end
