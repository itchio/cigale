
module Cigale::Property
  def translate_slack_property (xml, pdef)
    xml.teamDomain pdef["team-domain"]
    xml.token pdef["token"]
    xml.room pdef["room"]

    notify = toh pdef["notify"]

    xml.startNotification boolp(notify["start"], false)
    xml.notifySuccess boolp(notify["success"], false)
    xml.notifyAborted boolp(notify["aborted"], false)
    xml.notifyNotBuilt boolp(notify["not-built"], false)
    xml.notifyUnstable boolp(notify["unstable"], false)
    xml.notifyFailure boolp(notify["failure"], false)
    xml.notifyBackToNormal boolp(notify["back-to-normal"], false)
    xml.notifyRepeatedFailures boolp(notify["repeated-failure"], false)

    xml.includeTestSummary boolp(pdef["include-test-summary"], false)
    xml.showCommitList boolp(notify["show-commit-list"], false)

    xml.includeCustomMessage !!pdef["custom-message"]
    xml.customMessage pdef["custom-message"]
  end
end
