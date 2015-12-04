module Cigale::Publisher
  def translate_pmd_publisher (xml, pdef)
    xml.healthy pdef["healthy"]
    xml.unHealthy pdef["unhealthy"]
    xml.thresholdLimit pdef["health-threshold"] || "low"
    xml.pluginName "[PMD] "
    xml.defaultEncoding pdef["default-encoding"]
    xml.canRunOnFailed boolp(pdef["can-run-on-failed"], false)
    xml.useStableBuildAsReference boolp(pdef["use-stable-build-as-reference"], false)
    xml.useDeltaValues boolp(pdef["use-delta-values"], false)

    xml.thresholds do
      thresholds = pdef["thresholds"] || {}
      uthresh = thresholds["unstable"] || {}
      fthresh = thresholds["failed"] || {}

      %w(unstable failed).each do |a|
        %w(total new).each do |b|
          %w(all high normal low).each do |c|
            val = (thresholds[a] || {})["#{b}-#{c}"]

            unless (b == "new" && !val)
              xml.tag! "#{a}#{b.capitalize}#{c.capitalize}", val
            end
          end
        end
      end
    end

    xml.shouldDetectModules boolp(pdef["should-detect-modules"], false)
    xml.dontComputeNew boolp(pdef["dont-compute-new"], true)
    xml.doNotResolveRelativePaths boolp(pdef["do-not-resolve-relative-paths"], false)
    xml.pattern pdef["pattern"]
  end
end
