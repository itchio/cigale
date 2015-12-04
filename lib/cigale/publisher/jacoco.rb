module Cigale::Publisher
  def translate_jacoco_publisher (xml, pdef)
    xml.execPattern pdef["exec-pattern"]
    xml.classPattern pdef["class-pattern"]
    xml.sourcePattern pdef["source-pattern"]
    xml.changeBuildStatus
    xml.inclusionPattern
    xml.exclusionPattern

    targets = pdef["targets"] || {}

    for target in targets
      k, v = first_pair(target)
      xml.tag! "maximum#{k.capitalize}Coverage", v["healthy"]
      xml.tag! "minimum#{k.capitalize}Coverage", v["unhealthy"]
    end
  end
end
