module Cigale::Publisher
  def translate_ruby_metrics_publisher (xml, pdef)
    xml.reportDir pdef["report-dir"]

    xml.targets do
      covs = pdef["target"]
      %w(total code).each do |a|
        covs = target["#{a}-coverage"] || {}

        xml.tag! "hudson.plugins.rubyMetrix.rcov.model.MetricTarget" do
          xml.metric "#{a.upcase}_COVERAGE"

          %w(healthy unhealthy unstable).each do |b|
            xml.tag! b, covs[b]
          end
        end
      end
    end
  end
end
