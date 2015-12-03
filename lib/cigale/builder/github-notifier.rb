
module Cigale::Builder
  def translate_github_notifier_builder (xml, bdef)
    xml.tag! "com.cloudbees.jenkins.GitHubSetCommitStatusBuilder"
  end
end
