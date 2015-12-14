
module Cigale::Publisher
  def translate_slack_publisher (xml, pdef)
    xml.teamDomain pdef["team-domain"]
    xml.authToken pdef["auth-token"]
    xml.buildServerUrl pdef["build-server-url"]
  end
end
