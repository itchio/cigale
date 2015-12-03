
module Cigale::Publisher
  def translate_build_publisher_publisher (xml, pdef)
    xml.publishUnstableBuilds pdef["publish-unstable-builds"]
    xml.publishFailedBuilds pdef["publish-failed-builds"]
    days = pdef["days-to-keep"]
    num = pdef["num-to-keep"]

    if days || num
      xml.logRotator do
        xml.daysToKeep days
        xml.numToKeep num
        xml.artifactDaysToKeep -1
        xml.artifactNumToKeep -1
      end
    end
  end
end
