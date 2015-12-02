
module Cigale::Builder

  def translate_trigger_builds_builder (xml, bdef)
    xml.configs do
      for build in bdef
        xml.tag! "hudson.plugins.parameterizedtrigger.BlockableBuildTriggerConfig" do
          propfile = build["property-file"]
          predefparams = build["predefined-parameters"]
          boolparams = build["bool-parameters"]
          same_node = build["same-node"]
          currpar = build["current-parameters"]
          gitrev = build["git-revision"]
          svnrev = build["svn-revision"]
          nodelabel = build["node-label"]

          if propfile || boolparams || predefparams || same_node || currpar || gitrev || svnrev || nodelabel
            xml.configs do
              propfile and xml.tag! "hudson.plugins.parameterizedtrigger.FileBuildParameters" do
                xml.propertiesFile propfile
                tom = if build.has_key?("property-file-fail-on-missing")
                  build["property-file-fail-on-missing"]
                else
                  true
                end
                xml.failTriggerOnMissing tom
              end

              same_node and xml.tag! "hudson.plugins.parameterizedtrigger.NodeParameters"

              currpar and xml.tag! "hudson.plugins.parameterizedtrigger.CurrentBuildParameters"
              gitrev and xml.tag! "hudson.plugins.git.GitRevisionBuildParameters" do
                xml.combineQueuedCommits false
              end
              svnrev and xml.tag! "hudson.plugins.parameterizedtrigger.SubversionRevisionBuildParameters"

              predefparams and xml.tag! "hudson.plugins.parameterizedtrigger.PredefinedBuildParameters" do
                xml.properties predefparams
              end

              nodelabel and xml.tag! "org.jvnet.jenkins.plugins.nodelabelparameter.parameterizedtrigger.NodeLabelBuildParameter" do
                xml.name build["node-label-name"]
                xml.nodeLabel nodelabel
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
                fname = f["factory"]
                fclass = trigger_factories[fname] or raise "Unknown trigger param factory type: #{fname}"
                xml.tag! fclass do
                  case fname
                  when "allnodesforlabel"
                    xml.name f["name"]
                    xml.nodeLabel f["node-label"]
                    ign = if f.has_key?("ignore-offline-nodes")
                      f["ignore-offline-nodes"]
                    else true
                      true
                    end
                    xml.ignoreOfflineNodes ign
                  when "filebuild"
                    xml.filePattern f["file-pattern"]
                    xml.noFilesFoundAction f["no-files-found-action"] || "SKIP"
                  when "binaryfile"
                    xml.parameterName f["parameter-name"]
                    xml.filePattern f["file-pattern"]
                    xml.noFilesFoundAction f["no-files-found-action"] || "SKIP"
                  when "counterbuild"
                    xml.from f["from"]
                    xml.to f["to"]
                    xml.step f["step"]
                    xml.paramExpr f["parameters"]
                    xml.validationFail f["validation-fail"] || "FAIL"
                  end
                end
              end
            end
          end

          projects = build["project"]
          if Array === projects
            xml.projects projects.join(",")
          else
            xml.projects projects || "build_started"
          end
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
                  translate_build_status(xml, threshold)
                end
              end

              threshold = thresholds["unstable-threshold"]
              if threshold != "never"
                xml.unstableThreshold do
                  threshold = "UNSTABLE" if (threshold === true || threshold.nil?)
                  translate_build_status(xml, threshold)
                end
              end

              threshold = thresholds["failure-threshold"]
              if threshold != "never"
                xml.failureThreshold do
                  threshold = "FAILURE" if (threshold === true || threshold.nil?)
                  translate_build_status(xml, threshold)
                end
              end
            end # block
          end
        end # BlockableBuildTriggerConfig
      end # for b in builds
    end # configs

  end

  def trigger_factories
    @trigger_factories ||= {
      "allnodesforlabel" => "org.jvnet.jenkins.plugins.nodelabelparameter.parameterizedtrigger.AllNodesForLabelBuildParameterFactory",
      "filebuild" => "hudson.plugins.parameterizedtrigger.FileBuildParameterFactory",
      "binaryfile" => "hudson.plugins.parameterizedtrigger.BinaryFileParameterFactory",
      "counterbuild" => "hudson.plugins.parameterizedtrigger.CounterBuildParameterFactory",
    }
  end

end
