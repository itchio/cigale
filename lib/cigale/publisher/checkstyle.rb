module Cigale::Publisher
  def translate_checkstyle_publisher (xml, pdef)
    xml.healthy pdef["healthy"]
    xml.unHealthy pdef["unHealthy"] || pdef["unhealthy"]
    xml.thresholdLimit pdef["healthThreshold"] || pdef["health-threshold"] || "low"
    xml.pluginName "[CHECKSTYLE] "
    xml.defaultEncoding pdef["defaultEncoding"] || pdef["default-encoding"]
    xml.canRunOnFailed boolp(pdef["canRunOnFailed"] || pdef["can-run-on-failed"], false)
    xml.useStableBuildAsReference boolp(pdef["useStableBuildAsReference"] || pdef["use-stable-build-as-reference"], false)
    xml.useDeltaValues boolp(pdef["useDeltaValues"] || pdef["use-delta-values"], false)

    thresholds = pdef["thresholds"] || {}
    uthresh = thresholds["unstable"] || {}
    fthresh = thresholds["failed"] || {}

    xml.thresholds do
      xml.unstableTotalAll uthresh["totalAll"] || uthresh["total-all"]
      xml.unstableTotalHigh uthresh["totalHigh"] || uthresh["total-high"]
      xml.unstableTotalNormal uthresh["totalNormal"] || uthresh["total-normal"]
      xml.unstableTotalLow uthresh["totalLow"] || uthresh["total-low"]

      una = (uthresh["newAll"] || uthresh["new-all"]) and xml.unstableNewAll una
      unh = (uthresh["newHigh"] || uthresh["new-high"]) and xml.unstableNewHigh unh
      unn = (uthresh["newNormal"] || uthresh["new-normal"]) and xml.unstableNewNormal unn
      unl = (uthresh["newLow"] || uthresh["new-low"]) and xml.unstableNewLow unl

      xml.failedTotalAll fthresh["totalAll"] || fthresh["total-all"]
      xml.failedTotalHigh fthresh["totalHigh"] || fthresh["total-high"]
      xml.failedTotalNormal fthresh["totalNormal"] || fthresh["total-normal"]
      xml.failedTotalLow fthresh["totalLow"] || fthresh["total-low"]

      fna = (fthresh["newAll"] || fthresh["new-all"]) and xml.failedNewAll fna
      fnh = (fthresh["newHigh"] || fthresh["new-high"]) and xml.failedNewHigh fnh
      fnn = (fthresh["newNormal"] || fthresh["new-normal"]) and xml.failedNewNormal fnn
      fnl = (fthresh["newLow"] || fthresh["new-low"]) and xml.failedNewLow fnl
    end
    xml.shouldDetectModules boolp(pdef["shouldDetectModules"] || pdef["should-detect-modules"], false)

    xml.dontComputeNew boolp(pdef["dontComputeNew"] || pdef["dont-compute-new"], true)
    xml.doNotResolveRelativePaths boolp(pdef["doNotResolveRelativePaths"] || pdef["do-not-resolve-relative-paths"], false)
    xml.pattern pdef["pattern"]
  end
end
