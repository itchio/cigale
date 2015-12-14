
module Cigale::Property
  def translate_slack_property (xml, pdef)
    xml.teamDomain pdef["team-domain"]
    xml.token pdef["token"]
    xml.room pdef["room"]

    notify = toh pdef["notify"]

    xml.startNotification boolp(notify["start"], false)
    xml.startNotification boolp(notify["success"], false)
    xml.startNotification boolp(notify["aborted"], false)
    xml.startNotification boolp(notify["not-built"], false)
    xml.startNotification boolp(notify["unstable"], false)
    xml.startNotification boolp(notify["failure"], false)
    xml.startNotification boolp(notify["back-to-normal"], false)
    xml.startNotification boolp(notify["repeated-failure"], false)

    xml.startNotification boolp(pdef["include-test-summary"], false)
    xml.startNotification boolp(notify["show-commit-list"], false)

    xml.startNotification !!pdef["custom-message"]
    xml.customMessage pdef["custom-message"]
  end
end
