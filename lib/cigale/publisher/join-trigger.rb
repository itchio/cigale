module Cigale::Publisher
  def translate_join_trigger_publisher (xml, pdef)
    xml.joinProjects pdef["projects"].join(",")
    translate_publishers xml, "joinPublishers", pdef["publishers"]

    xml.evenIfDownstreamUnstable pdef["even-if-unstable"]
  end
end
