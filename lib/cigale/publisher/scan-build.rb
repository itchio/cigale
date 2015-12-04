module Cigale::Publisher
  def translate_scan_build_publisher (xml, pdef)
    xml.markBuildUnstableWhenThresholdIsExceeded boolp(pdef["mark-unstable"], false)
    xml.bugThreshold pdef["threshold"] || 0
    xml.clangexcludedpaths pdef["exclude-paths"]
  end
end
