
module Cigale::Builder::TriggerBuilds

  def translate_trigger_builds_builder (xml, bdef)
    xml.configs do
      for build in bdef
        xml.tag! "hudson.plugins.parameterizedtrigger.BlockableBuildTriggerConfig" do
          if propfile = build["property-file"]
            xml.configs do
              xml.tag! "hudson.plugins.parameterizedtrigger.FileBuildParameters" do
                xml.propertiesFile build["property-file"]
                xml.failTriggerOnMissing true
              end
            end
          else
            xml.configs :class => "java.util.Collections$EmptyList"
          end

          if factories = build["parameter-factories"]
            xml.configFactories do
              for f in factories
                fclass = trigger_factories[f["factory"]] or raise "Unknown trigger param factory type: #{f["factory"]}"
                xml.tag! fclass do
                  xml.name f["name"]
                  xml.nodeLabel f["node-label"]
                  xml.ignoreOfflineNodes f["ignore-offline-nodes"]
                end
              end
            end
          end

          xml.projects "build_started"
          xml.condition "ALWAYS"
          xml.triggerWithNoParameters false
          xml.buildAllNodesWithLabel false

          if build["block"]
            thresholds = build["block-thresholds"] || {}

            xml.block do
              threshold = thresholds["build-step-failure-threshold"]
              if threshold != "never"
                xml.buildStepFailureThreshold do
                  threshold = "FAILURE" if (threshold === true || threshold.nil?)
                  translate_trigger_build_threshold(xml, threshold)
                end
              end

              threshold = thresholds["unstable-threshold"]
              if threshold != "never"
                xml.unstableThreshold do
                  threshold = "UNSTABLE" if (threshold === true || threshold.nil?)
                  translate_trigger_build_threshold(xml, threshold)
                end
              end

              threshold = thresholds["failure-threshold"]
              if threshold != "never"
                xml.failureThreshold do
                  threshold = "FAILURE" if (threshold === true || threshold.nil?)
                  translate_trigger_build_threshold(xml, threshold)
                end
              end
            end # block
          end
        end # BlockableBuildTriggerConfig
      end # for b in builds
    end # configs

  end

  def translate_trigger_build_threshold (xml, threshold)
    @trigger_builds_thresholds ||= {
      "UNSTABLE" => {
        "name" => "UNSTABLE",
        "ordinal" => 1,
        "color" => "YELLOW",
        "completeBuild" => true,
      },
      "FAILURE" => {
        "name" => "FAILURE",
        "ordinal" => 2,
        "color" => "RED",
        "completeBuild" => true,
      },
    }

    tspec = @trigger_builds_thresholds[threshold] or raise "Unknown trigger build threshold: '#{threshold}'"
    for k, v in tspec
      xml.tag! k, v
    end
  end

  def trigger_factories
    @trigger_factories ||= {
      "allnodesforlabel" => "org.jvnet.jenkins.plugins.nodelabelparameter.parameterizedtrigger.AllNodesForLabelBuildParameterFactory",
    }
  end

end
