module Cigale::Publisher
  def translate_trigger_parameterized_builds_publisher (xml, pdef)
    xml.configs do
      for b in (pdef || [])
        xml.tag! "hudson.plugins.parameterizedtrigger.BuildTriggerConfig" do
          xml.configs do

            if predef = pdef["predefined-parameters"]
              xml.tag! "hudson.plugins.parameterizedtrigger.PredefinedBuildParameters" do
                xml.properties predef
              end
            end

            if propfile = pdef["property-file"]
              xml.tag! "hudson.plugins.parameterizedtrigger.FileBuildParameters" do
                xml.properties propfile
              end
            end

            if gitrev = pdef["git-revision"]
              xml.tag! "hudson.plugins.parameterizedtrigger.GitRevisionBuild" do
                xml.combineQueuedCommits false
              end
            end

            if matrix = pdef["restrict-matrix-project"]
              xml.tag! "hudson.plugins.parameterizedtrigger.matrix.MatrixSubsetBuildParameters" do
                xml.filter matrix
              end
            end

            if pdef["node-label"] || pdef["node-label-name"]
              xml.tag! "org.jvnet.jenkins.plugins.nodelabelparameter.parameterizedtrigger.NodeLabelBuildParameter" do
                xml.name pdef["node-label"]
                xml.nodeLabel pdef["node-label-name"]
              end
            end

          end # configs
        end # BuildTriggerConfig

        projects = b["project"]
        if Array === projects
          projects = projects.join(",")
        end
        xml.projects projects
        xml.condition "ALWAYS"
        xml.triggerWithNoParameters false
      end # for b in pdef
    end
  end
end
