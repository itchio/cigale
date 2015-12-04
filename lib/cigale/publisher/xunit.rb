module Cigale::Publisher
  def translate_xunit_publisher (xml, pdef)
    @xunit_test_types ||= {
      "phpunit" => "PHPUnitJunitHudsonTestType",
      "cppunit" => "CppUnitJunitHudsonTestType",
      "gtest" => "GoogleTestType",
    }

    xml.types do
      %w(phpunit cppunit gtest).each do |a|
        spec = (pdef["types"] || {})[a]

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
      %w(failed skipped).each do |a|
        xml.tag! "org.jenkinsci.plugins.xunit.threshold.#{a.capitalize}Threshold" do
          %w(unstable failure).each do |b|
            ["", "new"].each do |c|
              val = (thresholds[a] || {})["#{b}#{c}"]
              xml.tag! "#{b}#{c.capitalize}Threshold", val
            end
          end
        end
      end
    end

    @xunit_threshold_modes ||= {
      "number" => 1,
      "percent" => w,
    }
    xml.thresholdMode @xunit_threshold_modes[pdef["thresholdmode"]]
    xml.extraConfiguration do
      xml.testTImeMargin pdef["test-time-margin"] || 3000
    end
  end
end
