
require "cigale/property"
require "cigale/parameter"
require "cigale/wrapper"
require "cigale/scm"
require "cigale/builder"
require "cigale/publisher"
require "cigale/trigger"

include Cigale::Property
include Cigale::Parameter
include Cigale::Wrapper
include Cigale::SCM
include Cigale::Builder
include Cigale::Publisher
include Cigale::Trigger

module Cigale
  module Generator
    def translate_job (xml, jdef)
      @numjobs += 1

      type = jdef["project-type"]
      testcat = @opts[:test_category]

      project = case type
      when "matrix"
        "matrix-project"
      when "maven"
        "maven2-moduleset"
      when "flow"
        "com.cloudbees.plugins.flow.BuildFlow"
      when "multijob"
        "com.tikal.jenkins.plugins.multijob.MultiJobProject"
      when "externaljob"
        "hudson.model.ExternalJob"
      else
        "project"
      end

      xml.tag! project do
        case type
        when "matrix"
          translate_matrix_project xml, jdef
        when "maven"
          translate_maven_moduleset xml, jdef
        when "flow"
          translate_flow_project xml, jdef
        end # case project

        if testcat.nil? || testcat == "general"
          xml.actions
          if testcat.nil?
            if @opts[:masquerade]
              # to let tests pass
              xml.description "<!-- Managed by Jenkins Job Builder -->"
            else
              xml.description "<!-- Managed by cigale -->"
            end
          end
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

          if retcount = jdef["retry-count"]
            xml.scmCheckoutRetryCount retcount
          end
        end

        if testcat.nil? || testcat == "properties" || testcat == "parameters"
          translate_properties xml, jdef
        end

        if testcat.nil? || testcat == "scm"
          translate_scms xml, jdef["scm"]
        end

        if testcat.nil? || testcat == "triggers"
          tok = jdef["token"] and xml.authToken tok
          translate_triggers xml, jdef["triggers"]
        end

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
    end # translate

    # kind = 'property', 'parameter', 'builder'
    # type = 'scmpoll', 'github', etc.
    def translate (kind, xml, type, spec)
      if type == "raw"
        return insert_raw xml, spec
      end

      classes = self.send "#{kind}_classes"
      clazz = classes[type]
      raise "Unknown #{kind} type: #{type}" unless clazz

      method = method_for_translate(kind, type)

      case clazz
      when String
        xml.tag! clazz do
          self.send method, xml, spec
        end
      when Array
        xml.tag! *clazz do
          self.send method, xml, spec
        end
      else
        self.send method, xml, spec
      end
    end

    def method_for_translate (kind, type)
      "translate_#{underize(type)}_#{kind}"
    end

    def insert_raw (xml, spec)
      for l in spec["xml"].split("\n")
        xml.indent!
        xml << l + "\n"
      end
    end

    def translate_matrix_project (xml, jdef)
      exstrat = jdef["execution-strategy"] || {}
      xml.executionStrategy :class => "hudson.matrix.DefaultMatrixExecutionStrategyImpl" do
        xml.runSequentially boolp(exstrat["sequential"], false)

        if touchstone = exstrat["touchstone"]
          xml.touchStoneCombinationFilter touchstone["expr"]
          xml.touchStoneResultCondition do
            translate_build_status xml, touchstone["result"].upcase, false
          end
        end
      end


      if combfil = exstrat["combination-filter"]
        xml.combinationFilter combfil.strip
      else
        xml.combinationFilter
      end

      if axes = jdef["axes"]
        xml.axes do
          for a in axes
            axis = a.values.first

            name = axis["name"]

            clazz = case axis["type"]
            when "label-expression"
              "hudson.matrix.LabelExpAxis"
            when "slave"
              "hudson.matrix.LabelAxis"
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

    def translate_maven_moduleset (xml, jdef)
      mav = jdef["maven"]
      return unless mav

      if rootmod = mav["root-module"]
        xml.rootModule do
          xml.groupId rootmod["group-id"]
          xml.artifactId rootmod["artifact-id"]
        end
      end

      xml.goals mav["goals"]
      if mav["private-repository"]
        xml.localRepository :class => "hudson.maven.local_repo.PerJobLocalRepositoryLocator"
      end
      xml.ignoreUpstremChanges true # sic.
      xml.rootPOM mav["root-pom"]

      if mav["incremental-build"]
        xml.aggregatorStyleBuild false
        xml.incrementalBuild true
      else
        xml.aggregatorStyleBuild true
        xml.incrementalBuild false
      end

      xml.siteArchivingDisabled !boolp(mav["automatic-site-archiving"], true)
      xml.fingerprintingDisabled false
      xml.perModuleEmail true
      xml.archivingDisabled !boolp(mav["automatic-archiving"], true)
      xml.resolveDependencies !!mav["resolve-dependencies"]
      xml.processPlugins !!mav["process-plugins"]
      xml.mavenValidationLevel -1
      xml.runHeadless !!mav["run-headless"]
      if mavcw = mav["custom-workspace"]
        xml.customWorkspace mavcw
      end

      if mset = mav["settings"]
        if mset.start_with? "org.jenkinsci"
          xml.settings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnSettingsProvider" do
            xml.settingsConfigId mset
          end
        else
          xml.settings :class => "jenkins.mvn.FilePathSettingsProvider" do
            xml.path mset
          end
        end
      else
        xml.settings :class => "jenkins.mvn.DefaultSettingsProvider"
      end

      if mgset = mav["global-settings"]
        if mgset.start_with? "org.jenkinsci"
          xml.globalSettings :class => "org.jenkinsci.plugins.configfiles.maven.job.MvnGlobalSettingsProvider" do
            xml.settingsConfigId mgset
          end
        else
          xml.globalSettings :class => "jenkins.mvn.FilePathGlobalSettingsProvider" do
            xml.path mgset
          end
        end
      else
        xml.globalSettings :class => "jenkins.mvn.DefaultGlobalSettingsProvider"
      end

      xml.runPostStepsIfResult do
        status = mav["post-step-run-condition"] || "FAILURE"
        translate_build_status xml, status, false
      end
    end

    def translate_flow_project (xml, jdef)
      xml.dsl
      xml.buildNeedsWorkspace false
    end

  end # Generator
end # Cigale
