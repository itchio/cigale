module Cigale::Publisher
  def translate_pmd_publisher (xml, pdef)
    xml.healthy pdef["healthy"]
    xml.unHealthy pdef["unhealthy"]
    xml.thresholdLimit pdef["health-threshold"]
    xml.pluginName "[PMD] "
    xml.defaultEncoding pdef["default-encoding"]
    xml.canRunOnFailed pdef["can-run-on-failed"]
    xml.useStableBuildAsReference pdef["use-stable-build-as-reference"]
    xml.useDeltaValues pdef["use-delta-values"]

    xml.thresholds do
      thresholds = pdef["thresholds"] || {}
      uthresh = thresholds["unstable"] || {}
      fthresh = thresholds["failed"] || {}

      %w(unstable failed).each do |a|
        %w(total new).each do |b|
          %w(all high normal low).each do |c|
            val = (thresholds[a] || {})["#{b}-#{c}"]
            val and xml.tag! "#{a}#{b.capitalize}#{c.capitalize}", val
          end
        end
      end
    end

    xml.shouldDetectModules pdef["should-detect-modules"]
    xml.dontComputeNew pdef["dont-compute-new"]
    xml.doNotResolveRelativePaths pdef["do-not-resolve-relative-paths"]
    xml.pattern pdef["pattern"]
  end
end
