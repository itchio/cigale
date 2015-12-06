module Cigale::Publisher
  def translate_trigger_parameterized_builds_publisher (xml, pdef)
    xml.configs do
      for b in toa pdef
        xml.tag! "hudson.plugins.parameterizedtrigger.BuildTriggerConfig" do
          xml.configs do
            if current = b["current-parameters"]
              xml.tag! "hudson.plugins.parameterizedtrigger.CurrentBuildParameters"
            end
            if node = b["node-parameters"]
              xml.tag! "hudson.plugins.parameterizedtrigger.NodeParameters"
            end

            if predef = b["predefined-parameters"]
              xml.tag! "hudson.plugins.parameterizedtrigger.PredefinedBuildParameters" do
                xml.properties predef
              end
            end

            if propfile = b["property-file"]
              xml.tag! "hudson.plugins.parameterizedtrigger.FileBuildParameters" do
                xml.propertiesFile propfile
                xml.failTriggerOnMissing true
              end
            end

            if gitrev = b["git-revision"]
              xml.tag! "hudson.plugins.git.GitRevisionBuildParameters" do
                xml.combineQueuedCommits false
              end
            end

            if matrix = b["restrict-matrix-project"]
              xml.tag! "hudson.plugins.parameterizedtrigger.matrix.MatrixSubsetBuildParameters" do
                xml.filter matrix
              end
            end

            if b["node-label"] || b["node-label-name"]
              xml.tag! "org.jvnet.jenkins.plugins.nodelabelparameter.parameterizedtrigger.NodeLabelBuildParameter" do
                xml.name b["node-label-name"]
                xml.nodeLabel b["node-label"]
              end
            end

          end # configs

          projects = b["project"]
          if Array === projects
            projects = projects.join(",")
          end
          xml.projects projects
          xml.condition (b["condition"] || "always").upcase
          xml.triggerWithNoParameters boolp(b["trigger-with-no-params"], false)
        end # BuildTriggerConfig
      end # for b in pdef
    end
  end
end
