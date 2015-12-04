module Cigale::Publisher
  def translate_ruby_metrics_publisher (xml, pdef)
    xml.reportDir pdef["report-dir"]
    target = {}
    for t in pdef["target"]
      k, v = first_pair(t)
      target[k] = v
    end

    xml.targets do
      %w(total code).each do |a|
        covs = target["#{a}-coverage"] || {}

        xml.tag! "hudson.plugins.rubyMetrics.rcov.model.MetricTarget" do
          xml.metric "#{a.upcase}_COVERAGE"

          %w(healthy unhealthy unstable).each do |b|
            xml.tag! b, covs[b]
          end
        end
      end
    end
  end
end
