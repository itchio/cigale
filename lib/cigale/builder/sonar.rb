
module Cigale::Builder::Sonar
  def translate_sonar_builder (xml, bdef)
    xml.installationName bdef["sonar-name"]
    xml.task bdef["task"]
    xml.project bdef["project"]
    xml.properties bdef["properties"]
    xml.javaOpts bdef["java-opts"]
  end
end
