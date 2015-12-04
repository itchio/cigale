module Cigale::Publisher
  def translate_emotional_jenkins_publisher (xml, pdef)
    xml.tag! "org.jenkinsci.plugins.emotional__jenkins.EmotionalJenkinsPublisher"
  end
end
