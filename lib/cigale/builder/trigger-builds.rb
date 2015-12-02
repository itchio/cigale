
module Cigale::Builder::TriggerBuilds

  def translate_trigger_builds_builder (xml, bdef)
    xml.configs do
      for build in bdef
        xml.tag! "hudson.plugins.parameterizedtrigger.BlockableBuildTriggerConfig" do
          propfile = build["property-file"]
          predefparams = build["predefined-parameters"]
          boolparams = build["bool-parameters"]
          same_node = build["same-node"]

          if propfile || boolparams || predefparams || same_node
            xml.configs do
              propfile and xml.tag! "hudson.plugins.parameterizedtrigger.FileBuildParameters" do
                xml.propertiesFile propfile
                xml.failTriggerOnMissing true
              end

              same_node and xml.tag! "hudson.plugins.parameterizedtrigger.NodeParameters"

              predefparams and xml.tag! "hudson.plugins.parameterizedtrigger.PredefinedBuildParameters" do
                xml.properties predefparams
              end

              boolparams and xml.tag! "hudson.plugins.parameterizedtrigger.BooleanParameters" do
                xml.configs do
                  for bp in boolparams
                    xml.tag! "hudson.plugins.parameterizedtrigger.BooleanParameterConfig" do
                      xml.name bp["name"]
                      xml.value !!bp["value"]
                    end
                  end
                end
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
                  xml.ignoreOfflineNodes f["ignore-offline-nodes"] || true
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
