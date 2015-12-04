
require "cigale/property"
require "cigale/wrapper"
require "cigale/scm"
require "cigale/builder"
require "cigale/publisher"

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
    include Cigale::Property
    include Cigale::Wrapper
    include Cigale::SCM
    include Cigale::Builder
    include Cigale::Publisher

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
      testcat = @opts[:test_category]

      project = case type
      when "matrix"
        "matrix-project"
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

          if axes = jdef["axes"]
            xml.axes do
              for a in axes
                axis = a.values.first

                name = axis["name"]

                clazz = case axis["type"]
                when "user-defined"
                  "hudson.matrix.TextAxis"
                when "jdk"
                  name ||= "jdk"
                  "hudson.matrix.JDKAxis"
                when "python"
                  name ||= "PYTHON"
                  "jenkins.plugins.shiningpanda.matrix.PythonAxis"
                when "tox"
                  name ||= "TOXENV"
                  "jenkins.plugins.shiningpanda.matrix.ToxAxis"
                when "dynamic"
                  "ca.silvermaplesolutions.jenkins.plugins.daxis.DynamicAxis"
                else
                  raise "Unknown axis type: #{axis["type"]}"
                end

                xml.tag! clazz do
                  xml.name name
                  xml.values do
                    for v in axis["values"]
                      xml.string v
                    end
                  end

                  case axis["type"]
                  when "dynamic"
                    xml.varName axis["values"].first
                    xml.axisValues do
                      xml.string "default"
                    end
                  end
                end
              end # for a in axes
            end
          else
            xml.axes
          end
        end

        if testcat.nil? || testcat == "general"
          xml.actions
          xml.description "<!-- Managed by Jenkins Job Builder -->" if testcat.nil?
          xml.keepDependencies false
          xml.blockBuildWhenDownstreamBuilding false
          xml.blockBuildWhenUpstreamBuilding false
          xml.concurrentBuild false
          if val = jdef["workspace"]
            xml.customWorkspace val
          end
          if val = jdef["child-workspace"] and type == "matrix"
            xml.childCustomWorkspace val
          end

          if node = jdef["node"]
            xml.assignedNode node
            xml.canRoam false
          else
            xml.canRoam true
          end
        end

        if testcat.nil? || testcat == "properties"
          translate_properties xml, jdef["properties"]
        end

        if testcat.nil? || testcat == "scm"
          translate_scms xml, jdef["scm"]
        end
        translate_triggers xml, jdef["triggers"]

        if testcat.nil? || testcat == "builders"
          if post = jdef["postbuilders"]
            translate_builders xml, "postbuilders", jdef["postbuilders"]
          end
          translate_builders xml, "builders", jdef["builders"]
        end

        if testcat.nil? || testcat == "publishers"
          translate_publishers xml, "publishers", jdef["publishers"]
        end

        if testcat.nil? || testcat == "wrappers"
          translate_wrappers xml, jdef["wrappers"]
        end
      end
    end

  end # Generator
end # Cigale
