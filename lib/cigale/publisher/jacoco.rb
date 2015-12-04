module Cigale::Publisher
  def translate_jacoco_publisher (xml, pdef)
    xml.execPattern pdef["exec-pattern"]
    xml.classPattern pdef["class-pattern"]
    xml.sourcePattern pdef["source-pattern"]
    xml.changeBuildStatus
    xml.inclusionPattern
    xml.exclusionPattern

    targets = pdef["targets"] || {}
    btarget = targets["branch"] || {}
    xml.maximumBranchCoverage btarget["healthy"]
    xml.minimumBranchCoverage btarget["unhealthy"]

    mtarget = targets["method"] || {}
    xml.maximumMethodCoverage mtarget["healthy"]
    xml.minimumMethodCoverage mtarget["unhealthy"]
  end
end
