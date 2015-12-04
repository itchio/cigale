module Cigale::Publisher
  def translate_xunit_publisher (xml, pdef)
    @xunit_test_types ||= {
      "phpunit" => "PHPUnitJunitHudsonTestType",
      "cppunit" => "CppUnitJunitHudsonTestType",
      "gtest" => "GoogleTestType",
      "ctest" => "CTestType",
    }

    xml.types do
      types = {}
      for t in pdef["types"] do
        k, v = first_pair(t)
        types[k] = v
      end

      %w(phpunit cppunit gtest ctest).each do |a|
        spec = types[a]
        next unless spec

        xml.tag! @xunit_test_types[a] do
          xml.pattern spec["pattern"]
          xml.failIfNotNew boolp(spec["fail-if-not-new"], true) # XXX
          xml.deleteOutputFiles boolp(spec["delete-output-files"], true) # XXX
          xml.skipNoTestFiles boolp(spec["skip-if-no-test-files"], false)
          xml.stopProcessingIfError boolp(spec["stop-on-error"], true)
        end
      end
    end

    xml.thresholds do
      thresholds = {}
      for t in pdef["thresholds"]
        k, v = first_pair(t)
        thresholds[k] = v
      end

      %w(failed skipped).each do |a|
        xml.tag! "org.jenkinsci.plugins.xunit.threshold.#{a.capitalize}Threshold" do
          %w(unstable failure).each do |b|
            ["", "new"].each do |c|
              val = (thresholds[a] || {})["#{b}#{c}"]
              val = nil if val == 0
              xml.tag! "#{b}#{c.capitalize}Threshold", val
            end
          end
        end
      end
    end

    @xunit_threshold_modes ||= {
      "number" => 1,
      "percent" => 2,
    }
    xml.thresholdMode @xunit_threshold_modes[pdef["thresholdmode"]]
    xml.extraConfiguration do
      xml.testTimeMargin pdef["test-time-margin"] || 3000
    end
  end
end
