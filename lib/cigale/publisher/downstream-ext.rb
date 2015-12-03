module Cigale::Publisher
  def translate_downstream_ext_publisher (xml, pdef)
    xml.childProjects (pdef["projects"] || []).join(",")

    threshold = pdef["criteria"] || "success"
    xml.threshold do
      translate_build_status xml, threshold.upcase
    end
    xml.thresholdStrategy underize(pdef["condition"] || "and-higher").upcase
    xml.onlyIfSCMChanges boolp(pdef["only-on-scm-change"], false)
    xml.onlyIfLocalSCMChanges boolp(pdef["only-on-local-scm-change"], false)
  end
end
