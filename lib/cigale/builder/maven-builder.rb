
module Cigale::Builder
  def translate_maven_builder_builder (xml, bdef)
    xml.mavenName bdef["name"]
    xml.goals bdef["goals"]
    xml.rootPom bdef["pom"]
    xml.mavenOpts
  end
end
