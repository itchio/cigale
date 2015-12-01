
module Cigale
  module SCM
    module Git
      def translate_git_scm (xml, sdef)
        xml.configVersion 2
        xml.userRemoteConfigs do
          xml.tag! "hudson.plugins.git.UserRemoteConfig" do
            remote_name = sdef["name"] || "origin"
            xml.name remote_name
            xml.refspec sdef["refspec"] || "+refs/heads/*:refs/remotes/#{remote_name}/*"
            xml.url sdef["url"]
            if val = sdef["credentials-id"]
              xml.credentialsId val
            end
          end
        end

        xml.branches do
          branches = sdef["branches"] || ["**"]
          for branch in branches
            xml.tag! "hudson.plugins.git.BranchSpec" do
              xml.name branch
            end
          end
        end

        xml.excludedUsers
        xml.buildChooser :class => "hudson.plugins.git.util.DefaultBuildChooser"

        subdef = sdef["submodule"]

        if subdef.nil?
          xml.disableSubmodules false
          xml.recursiveSubmodules false
        end
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
          if subdef
            xml.tag! "hudson.plugins.git.extensions.impl.SubmoduleOption" do
              xml.disableSubmodules subdef["disable"]
              xml.recursiveSubmodules subdef["recursive"]
              xml.trackingSubmodules subdef["tracking"]
              xml.timeout subdef["timeout"] || "10"
            end
          end

          xml.tag! "hudson.plugins.git.extensions.impl.WipeWorkspace"
        end
      end
    end

  end
end
