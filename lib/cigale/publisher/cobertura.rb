module Cigale::Publisher
  def translate_cobertura_publisher (xml, pdef)
    xml.coberturaReportFile pdef["report-file"]
    xml.onlyStable pdef["only-stable"]
    xml.failUnhealthy pdef["fail-unhealthy"]
    xml.failUnstable pdef["fail-unstable"]
    xml.autoUpdateHealth pdef["health-auto-update"]
    xml.autoUpdateStability pdef["stability-auto-update"]
    xml.zoomCoverageChart pdef["zoom-coverage-chart"]
    xml.failNoReports pdef["fail-no-reports"]

    targets = {
      "healthy" => {},
      "unhealthy" => {},
      "failing" => {},
    }

    for target in pdef["targets"]
      metric, values = first_pair(target)
      values.each do |state, value|
        targets[state][metric] = value
      end
    end

    targets.each do |state, metrics|
      xml.tag! "#{state}Target" do
        xml.targets :class => "enum-map", :"enum-type" => "hudson.plugins.cobertura.targets.CoverageMetric" do
          metrics.each do |metric, value|
            xml.entry do
              xml.tag! "hudson.plugins.cobertura.targets.CoverageMetric", metric.upcase
              xml.int value
            end
          end
        end # targets class=enum-map
      end
    end # each metric

    xml.sourceEncoding pdef["source-encoding"]
  end
end
