module Cigale::Publisher
  def translate_cppcheck_publisher (xml, pdef)
    xml.cppcheckConfig do
      xml.pattern pdef["pattern"]
      xml.ignoreBlankFiles false

      thresholds = pdef["thresholds"] || {}
      xml.configSeverityEvaluation do
        xml.threshold thresholds["unstable"]
        xml.newThreshold thresholds["new-unstable"]
        xml.failureThreshold thresholds["failure"]
        xml.newFailureThreshold thresholds["new-failure"]

        xml.healthy
        xml.unHealthy

        severities = thresholds["severity"] || {}

        xml.severityError boolp(severities["error"], true)
        xml.severityWarning boolp(severities["warning"], true)
        xml.severityStyle boolp(severities["style"], true)
        xml.severityPerformance boolp(severities["performance"], true)
        xml.severityInformation boolp(severities["information"], true)
      end

      graph = pdef["graph"] || {}
      xml.configGraph do
        xysize = graph["xysize"] || []
        xml.xSize xysize[0]
        xml.ySize xysize[1]

        display = graph["display"] || {}
        xml.displayAllErrors boolp(display["sum"], true)
        xml.displayErrorSeverity boolp(display["error"], false)
        xml.displayWarningSeverity boolp(display["warning"], false)
        xml.displayStyleSeverity boolp(display["style"], false)
        xml.displayPerformanceSeverity boolp(display["performance"], false)
        xml.displayInformationSeverity boolp(display["information"], false)
      end
    end
  end
end
