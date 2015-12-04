module Cigale::Publisher
  def translate_scoverage_publisher (xml, pdef)
    xml.reportDir pdef["report-directory"]
    xml.reportFile pdef["report-file"]
  end
end
