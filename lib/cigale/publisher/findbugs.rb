module Cigale::Publisher
  def translate_findbugs_publisher (xml, pdef)
    xml.tag! "hudson.plugins.findbugs.FindBugsPublisher", :plugin => "findbugs" do
      xml.isRankActivated pdef["rank-priority"]
      xml.includePattern pdef["include-files"]
      xml.excludePattern pdef["exclude-files"]
      xml.usePreviousBuildAsReference pdef["use-previous-build-as-reference"]
      xml.healthy pdef["healthy"]
      xml.unHealthy pdef["unhealthy"]
      xml.thresholdLimit pdef["health-threshold"]
      xml.pluginName "[FINDBUGS] "
      xml.defaultEncoding
      xml.canRunOnFailed pdef["can-run-on-failed"]
      xml.useStableBuildAsReference pdef["use-stable-build-as-reference"]
      xml.useDeltaValues pdef["use-delta-values"]

      xml.thresholds do
        thresholds = pdef["thresholds"] || {}
        uthresh = thresholds["unstable"] || {}
        fthresh = thresholds["failed"] || {}

        xml.unstableTotalAll uthresh["total-all"]
        xml.unstableTotalHigh uthresh["total-high"]
        xml.unstableTotalNormal uthresh["total-normal"]
        xml.unstableTotalLow uthresh["total-low"]
        xml.unstableNewAll uthresh["new-all"]
        xml.unstableNewHigh uthresh["new-high"]
        xml.unstableNewNormal uthresh["new-normal"]
        xml.unstableNewLow uthresh["new-low"]

        xml.failedTotalAll fthresh["total-all"]
        xml.failedTotalHigh fthresh["total-high"]
        xml.failedTotalNormal fthresh["total-normal"]
        xml.failedTotalLow fthresh["total-low"]
        xml.failedNewAll fthresh["new-all"]
        xml.failedNewHigh fthresh["new-high"]
        xml.failedNewNormal fthresh["new-normal"]
        xml.failedNewLow fthresh["new-low"]
      end
      xml.shouldDetectModules pdef["should-detect-modules"]
      xml.dontComputeNew pdef["dont-compute-new"]
      xml.doNotResolveRelativePaths false
      xml.pattern pdef["pattern"]
    end
  end
end
