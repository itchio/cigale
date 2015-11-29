require "cigale/version"
require "logger"
require "slop"
require "yaml"
require "fileutils"
require "builder"

module Cigale
  class CLI
    def initialize
      @logger = Logger.new($stdout).tap do |log|
        log.progname = "cigale"
      end

      opts = Slop.parse ARGV do |o|
        o.banner = "Usage: cigale [options] [spec_file.yml]"

        o.string "-o", "output", "Output directory", :default => "."
      end

      cmd, input = opts.arguments
      case cmd
      when "test"
        # cool
      else
        puts "Unknown command: #{cmd}"
        exit 1
      end

      @logger.info "Parsing #{input}" 
      entries = YAML.load_file(input)

      output = opts[:output]
      @logger.info "Creating directory #{output}" 
      FileUtils.mkdir_p output

      for entry in entries
        case entry.keys.first
        when "job"
          job_def = entry.values.first

          xml = Builder::XmlMarkup.new(:indent => 2)
          xml.instruct! :xml, :version => "1.0", :encoding => "utf-8"

          translate_project xml, job_def

          job_path = File.join(output, job_def["name"])
          File.open(job_path, "w") do |f|
            f.write(xml.target!)
          end
        else
          raise "Unknown top-level type: #{}"
        end
      end
    end

    def translate_project (xml, job_def)
      xml.tag! "matrix-project" do
        xml.executionStrategy :class => "hudson.matrix.DefaultMatrixExecutionStrategyImpl" do
          xml.runSequentially false
        end
        xml.combinationFilter
        xml.axes
        xml.actions
        xml.description "<!-- Managed by Jenkins Job Builder -->"
        xml.keepDependencies false
        xml.blockBuildWhenDownstreamBuilding false
        xml.blockBuildWhenUpstreamBuilding false
        xml.concurrentBuild false
        xml.canRoam true
        xml.properties
        translate_scm xml, job_def
        xml.builders
        xml.publishers
        xml.buildWrappers
      end
    end

    def translate_scm (xml, job_def)
      classes = {
        "nil" => "hudson.scm.NullSCM",
        "git" => "hudson.plugins.git.GitSCM",
      }

      if job_def["scm"].nil?
        xml.scm :class => classes["nil"]
        return
      end

      for scm in job_def["scm"]
        xml.scm :class => classes[scm.keys.first] do
          scm_def = scm.values.first
          case scm_type = scm.keys.first
          when "git"
            xml.configVersion 2
            xml.userRemoteConfigs do
              xml.tag! "hudson.plugins.git.UserRemoteConfig" do
                xml.name scm_def["name"] || "origin"
                xml.refspec scm_def["refspec"] || "+refs/heads/*:refs/remotes/remoteName/*"
                xml.url scm_def["url"]
                xml.credentialsId scm_def["credentials-id"]
              end
            end

            xml.branches do
              for branch in scm_def["branches"]
                xml.tag! "hudson.plugins.git.BranchSpec" do
                  xml.name branch
                end
              end
            end

            xml.excludedUsers
            xml.buildChooser :class => "hudson.plugins.git.util.DefaultBuildChooser"
            xml.disableSubmodules false
            xml.recursiveSubmodules false
            xml.doGenerateSubmoduleConfigurations false
            xml.authorOrCommitter false
            xml.wipeOutWorkspace true
            xml.pruneBranches false
            xml.remotePoll false
            xml.gitTool "Default"
            xml.submoduleCfg :class => "list"
            xml.relativeTargetDir
            xml.reference
            xml.gitConfigName
            xml.gitConfigEmail
            xml.skipTag false
            xml.scmName
            xml.useShallowClone false
            xml.ignoreNotifyCommit false
            xml.extensions do
              xml.tag! "hudson.plugins.git.extensions.impl.WipeWorkspace"
            end
          end
        end
      end
    end
  end
end
