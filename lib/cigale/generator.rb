require "cigale/scm"
require "cigale/builder"

require "builder/xmlbase"

module Builder
  class XmlBase
    def indent!
      _indent
    end
  end
end

module Cigale
  module Generator
    include Cigale::SCM
    include Cigale::Builder

    def coerce_array (input)
      case input
      when Array
        return input
      when nil
        return []
      else
        return [input]
      end
    end

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

        if (not testing) || @opts[:test_category] == "scm"
          translate_scms xml, jdef["scm"]
        end
        translate_triggers xml, jdef["triggers"]

        if (not testing) || @opts[:test_category] == "builders"
          if post = jdef["postbuilders"]
            translate_builders xml, "postbuilders", jdef["postbuilders"]
          end
          translate_builders xml, "builders", jdef["builders"]
        end

        unless testing
          xml.publishers
          xml.buildWrappers
        end
      end
    end

  end # Generator
end # Cigale
