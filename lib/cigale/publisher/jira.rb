module Cigale::Publisher
  def translate_jira_publisher (xml, pdef)
    xml.tag! "hudson.plugins.jira.JiraIssueUpdater"
  end
end
