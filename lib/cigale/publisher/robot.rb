module Cigale::Publisher
  def translate_robot_publisher (xml, pdef)
    xml.outputPath pdef["output-path"]
    xml.logFileLink pdef["log-file-link"]
    xml.reportFileName pdef["report-html"]
    xml.logFileName pdef["log-html"]
    xml.outputFileName pdef["output-xml"]
    xml.passThreshold pdef["pass-threshold"]
    xml.unstableThreshold pdef["unstable-threshold"]
    xml.onlyCritical pdef["only-critical"]
    xml.otherFiles do
      for f in pdef["other-files"] do
        xml.string f
      end
    end

    xml.disableArchiveOutput !pdef["archive-output-xml"]
  end
end
