
module Cigale::Builder

  def translate_multijob_builder (xml, bdef)
    xml.phaseName bdef["name"]
    xml.continuationCondition bdef["condition"]
    xml.phaseJobs do
      for project in bdef["projects"]
        xml.tag! "com.tikal.jenkins.plugins.multijob.PhaseJobsConfig" do
          xml.jobName project["name"]
          xml.currParams project["current-parameters"]

          nodelabel = project["node-label"]
          has_gitrev = project.has_key?("git-revision")
          propfile = project["property-file"]
          preparams = project["predefined-parameters"]

          if nodelabel || has_gitrev || propfile || preparams
            xml.configs do
              if nodelabel
                xml.tag! "org.jvnet.jenkins.plugins.nodelabelparameter.parameterizedtrigger.NodeLabelBuildParameter" do
                  xml.name project["node-label-name"]
                  xml.nodeLabel nodelabel
                end
              end

              if has_gitrev
                gitrev = project["git-revision"]
                xml.tag! "hudson.plugins.git.GitRevisionBuildParameters" do
                  xml.combineQueuedCommits !gitrev
                end
              end

              if propfile
                xml.tag! "hudson.plugins.parameterizedtrigger.FileBuildParameters" do
                  xml.propertiesFile propfile
                  xml.failTriggerOnMissing true
                end
              end

              if preparams
                xml.tag! "hudson.plugins.parameterizedtrigger.PredefinedBuildParameters" do
                  xml.properties preparams
                end
              end
            end # configs
          else
            xml.configs
          end

          if encond = project["enable-condition"]
            xml.enableCondition true
            xml.condition encond
          end

          if killphase = project["kill-phase-on"]
            xml.killPhaseOnJobResultCondition killphase
          end

        end
      end
    end
  end

end
