module Cigale::Publisher
  def translate_valgrind_publisher (xml, pdef)
    xml.pattern pdef["pattern"]

    @valgrind_thresholds ||= {
      "invalid-read-write" => "InvalidReadWrite",
      "definitely-lost" => "DefinitelyLost",
      "total" => "Total",
    }

    thresholds = pdef["thresholds"] || {}
    %w(unstable fail).each do |a|
      thresh = thresholds[a]

      %w(invalid-read-write definitely-lost total).each do |b|
        val = thresh[b] and xml.tag! "#{a}#{@valgrind_thresholds[b]}", val
      end
    end

    xml.failBuildOnMissingReports pdef["fail-no-reports"]
    xml.failBuildOnInvalidReports pdef["fail-invalid-reports"]
    xml.publishResultsForAbortedBuilds pdef["publish-if-aborted"]
    xml.publishResultsForFailedBuilds pdef["publish-if-failed"]
  end
end
