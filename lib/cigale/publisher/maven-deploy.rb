module Cigale::Publisher
  def translate_maven_deploy_publisher (xml, pdef)
    xml.id pdef["id"]
    xml.url pdef["url"]
    xml.uniqueVersion pdef["unique-version"]
    xml.evenIfUnstable pdef["deploy-unstable"]
    xml.releaseEnvVar pdef["release-env-var"]
  end
end
