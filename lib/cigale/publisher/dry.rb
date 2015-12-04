module Cigale::Publisher
  def translate_dry_publisher (xml, pdef)
    xml.healthy pdef["healthy"]
    xml.unHealthy pdef["unhealthy"]
    xml.thresholdLimit pdef["health-threshold"] || "low"
    xml.pluginName "[DRY] "
    xml.defaultEncoding pdef["default-encoding"]
    xml.canRunOnFailed boolp(pdef["can-run-on-failed"], false)
    xml.useStableBuildAsReference boolp(pdef["use-stable-build-as-reference"], false)
    xml.useDeltaValues boolp(pdef["use-delta-values"], false)
    xml.thresholds do
      thresholds = pdef["thresholds"] || {}

      uthresh = thresholds["unstable"] || {}
      xml.unstableTotalAll uthresh["total-all"]
      xml.unstableTotalHigh uthresh["total-high"]
      xml.unstableTotalNormal uthresh["total-normal"]
      xml.unstableTotalLow uthresh["total-low"]

      una = uthresh["new-all"] and xml.unstableNewAll una
      unh = uthresh["new-high"] and xml.unstableNewHigh unh
      unn = uthresh["new-normal"] and xml.unstableNewNormal unn
      unl = uthresh["new-low"] and xml.unstableNewLow unl

      fthresh = thresholds["failed"] || {}
      xml.failedTotalAll fthresh["total-all"]
      xml.failedTotalHigh fthresh["total-high"]
      xml.failedTotalNormal fthresh["total-normal"]
      xml.failedTotalLow fthresh["total-low"]

      fna = fthresh["new-all"] and xml.failedNewAll fna
      fnh = fthresh["new-high"] and xml.failedNewHigh fnh
      fnn = fthresh["new-normal"] and xml.failedNewNormal fnn
      fnl = fthresh["new-low"] and xml.failedNewLow fnl
    end
    xml.shouldDetectModules boolp(pdef["should-detect-modules"], false)
    xml.dontComputeNew boolp(pdef["dont-compute-new"], true)
    xml.doNotResolveRelativePaths boolp(pdef["do-not-resolve-relative-paths"], false)
    xml.pattern pdef["pattern"]
    xml.highThreshold pdef["high-threshold"] || 50
    xml.normalThreshold pdef["normal-threshold"] || 25
  end
end
