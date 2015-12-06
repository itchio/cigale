module Cigale::Publisher
  def translate_cobertura_publisher (xml, pdef)
    xml.coberturaReportFile pdef["report-file"]
    xml.onlyStable pdef["only-stable"]

    pdef.has_key?("fail-unhealthy") and xml.failUnhealthy pdef["fail-unhealthy"]
    pdef.has_key?("fail-unstable") and xml.failUnstable pdef["fail-unstable"]
    pdef.has_key?("health-auto-update") and xml.autoUpdateHealth pdef["health-auto-update"]
    pdef.has_key?("stability-auto-update") and xml.autoUpdateStability pdef["stability-auto-update"]
    pdef.has_key?("zoom-coverage-chart") and xml.zoomCoverageChart pdef["zoom-coverage-chart"]
    pdef.has_key?("fail-no-reports") and xml.failNoReports pdef["fail-no-reports"]

    targets = {
      "healthy" => {},
      "unhealthy" => {},
      "failing" => {},
    }

    for target in toa pdef["targets"]
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
