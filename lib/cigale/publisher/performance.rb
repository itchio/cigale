module Cigale::Publisher
  def translate_performance_publisher (xml, pdef)
    xml.errorFailedThreshold pdef["failed-threshold"]
    xml.errorUnstableThreshold pdef["unstable-threshold"]

    xml.parsers do
      for report in (pdef["report"] || [])
        k = report
        v = nil
        if Hash === report
          k, v = first_pair(report)
        end

        clazz = case k
        when "jmeter"
          v ||= "**/*.jtl"
          "JMeterParser"
        when "junit"
          v ||= "**/TEST-*.xml"
          "JUnitParser"
        else
          raise "Unknown performance parser: #{k}"
        end

        xml.tag! "hudson.plugins.performance.#{clazz}" do
          xml.glob v
        end
      end
    end # parsers
  end
end
