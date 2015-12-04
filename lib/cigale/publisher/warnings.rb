module Cigale::Publisher
  def translate_warnings_publisher (xml, pdef)
    xml.consoleParsers do
      for parser in pdef["console-log-parsers"]
        xml.tag! "hudson.plugins.warnings.ConsoleParser" do
          xml.parserName parser
        end
      end
    end

    xml.parserConfigurations do
      for scanner in pdef["workspace-file-scanners"]
        xml.tag! "hudson.plugins.warnings.ParserConfiguration" do
          xml.pattern scanner["file-pattern"]
          xml.parserName scanner["scanner"]
        end
      end
    end

    xml.includePattern pdef["files-to-include"]
    xml.excludePattern pdef["files-to-ignore"]
    xml.canRunOnFailed pdef["run-always"]
    xml.shouldDetectModules pdef["detect-modules"]
    xml.doNotResolveRelativePaths !pdef["resolve-relative-paths"]
    xml.healthy pdef["health-threshold-high"]
    xml.unHealthy pdef["health-threshold-low"]
    xml.thresholdLimit pdef["health-priorities"].split("-").last # XXX wat

    xml.thresholds do
      %w(total new).each do |b|
        %w(unstable failed).each do |a|
          %w(all high normal low).each do |c|
            val = ((pdef["#{b}-thresholds"] || {})[a] || {})["#{b}-#{c}"]
            val and xml.tag! "#{a}#{b.capitalize}#{c.capitalize}", val
          end
        end
      end
    end

    xml.dontComputeNew false
    xml.useDeltaValues pdef["use-delta-for-new-warnings"]
    xml.useStableBuildAsReference pdef["only-use-stable-builds-as-reference"]
    xml.defaultEncoding pdef["default-encoding"]
  end
end
