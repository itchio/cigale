
require "cigale/scm/git"

module Cigale
  module Generator
    include Cigale::SCM::Git

    def translate_job (xml, jdef)
      @numjobs += 1

      type = jdef["project-type"]
      testing = (type == "test")

      project = case type
      when "matrix"
        "matrix-project"
      when "test"
        "project"
      else
        "project"
      end

      xml.tag! project do
        case project
        when "matrix-project"
          xml.executionStrategy :class => "hudson.matrix.DefaultMatrixExecutionStrategyImpl" do
            xml.runSequentially false
          end
          xml.combinationFilter
          xml.axes
        end

        unless testing
          xml.actions
          xml.description "<!-- Managed by Jenkins Job Builder -->"
          xml.keepDependencies false
          xml.blockBuildWhenDownstreamBuilding false
          xml.blockBuildWhenUpstreamBuilding false
          xml.concurrentBuild false
          if val = jdef["workspace"]
            xml.customWorkspace val
          end
          if val = jdef["child-workspace"]
            xml.childCustomWorkspace val
          end
          xml.canRoam true
          xml.properties
        end

        translate_scm xml, jdef["scm"]
        translate_triggers xml, jdef["triggers"]

        unless testing
          translate_builders xml, jdef["builders"]
          xml.publishers
          xml.buildWrappers
        end
      end
    end
  end
end
