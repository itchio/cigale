module Cigale::Publisher
  def translate_github_notifier_publisher (xml, pdef)
    xml.tag! "com.cloudbees.jenkins.GitHubCommitNotifier"
  end
end
