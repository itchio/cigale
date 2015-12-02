
module Cigale::SCM
  def translate_git_scm (xml, sdef)
    xml.configVersion 2

    xml.userRemoteConfigs do
      if remotes = sdef["remotes"]
        for r in remotes
          remote_name, rdef = first_pair(r)
          xml.tag! "hudson.plugins.git.UserRemoteConfig" do
            xml.name remote_name
            xml.refspec rdef["refspec"] || "+refs/heads/*:refs/remotes/#{remote_name}/*"
            xml.url rdef["url"]
            cri = rdef["credentials-id"] and xml.credentialsId cri
          end
        end
      else
        xml.tag! "hudson.plugins.git.UserRemoteConfig" do
          remote_name = sdef["name"] || "origin"
          xml.name remote_name
          xml.refspec sdef["refspec"] || "+refs/heads/*:refs/remotes/#{remote_name}/*"
          xml.url sdef["url"]
          cri = sdef["credentials-id"] and xml.credentialsId cri
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

    if mopts = sdef["merge"]
      xml.userMergeOptions do
        xml.mergeRemote mopts["remote"]
        xml.mergeTarget mopts["branch"]
        xml.mergeStrategy mopts["strategy"]
        xml.fastForwardMode mopts["fast-forward-mode"]
      end
    end

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
    xml.useShallowClone sdef["shallow-clone"] || false
    xml.ignoreNotifyCommit sdef["ignore-notify"] || false

    lb = sdef["local-branch"] and xml.localBranch lb

    xml.extensions do
      if val = sdef["changelog-against"]
        xml.tag! "hudson.plugins.git.extensions.impl.ChangelogToBranch" do
          xml.options do
            xml.compareRemote val["remote"]
            xml.compareTarget val["branch"]
          end
        end
      end

      timeout = sdef["timeout"] and xml.tag! "hudson.plugins.git.extensions.impl.CheckoutOption" do
        xml.timeout timeout
      end

      subdef and xml.tag! "hudson.plugins.git.extensions.impl.SubmoduleOption" do
        xml.disableSubmodules subdef["disable"]
        xml.recursiveSubmodules subdef["recursive"]
        xml.trackingSubmodules subdef["tracking"]
        xml.timeout subdef["timeout"] || 10
      end

      sdef["force-polling-using-workspace"] and xml.tag! "hudson.plugins.git.extensions.impl.DisableRemotePoll"

      exclRegions = sdef["excluded-regions"] || []
      inclRegions = sdef["included-regions"] || []
      unless exclRegions.empty? && inclRegions.empty?
        xml.tag! "hudson.plugins.git.extensions.impl.PathRestriction" do
          exclRegions.empty? or xml.tag! "excludedRegions", exclRegions.join("\n")
          inclRegions.empty? or xml.tag! "includedRegions", inclRegions.join("\n")
        end
      end

      if cl = sdef["clean"]
        case cl
        when Hash
          cl["after"] and xml.tag! "hudson.plugins.git.extensions.impl.CleanCheckout"
          cl["before"] and xml.tag! "hudson.plugins.git.extensions.impl.CleanBeforeCheckout"
        else
          xml.tag! "hudson.plugins.git.extensions.impl.CleanCheckout"
        end
      end

      if sch = sdef["sparse-checkout"]
        xml.tag! "hudson.plugins.git.extensions.impl.SparseCheckoutPaths" do
          xml.sparseCheckoutPaths do
            for path in sch["paths"]
              xml.tag! "hudson.plugins.git.extensions.impl.SparseCheckoutPath" do
                xml.path path
              end
            end
          end
        end
      end

      if ign = sdef["ignore-commits-with-messages"]
        for pattern in ign
          xml.tag! "hudson.plugins.git.extensions.impl.MessageExclusion" do
            xml.excludedMessage pattern
          end
        end
      end

      xml.tag! "hudson.plugins.git.extensions.impl.WipeWorkspace"
    end

    if browser = sdef["browser"]
      bclass = git_browser_classes[browser] or raise "Unknown git browser type #{browser}"
      xml.browser :class => bclass do
        url = sdef["browser-url"] and xml.url url
        ver = sdef["browser-version"] and xml.version ver
      end
    end
  end

  def git_browser_classes
    @git_browser_classes ||= {
      "githubweb" => "hudson.plugins.git.browser.GithubWeb",
      "rhodecode" => "hudson.plugins.git.browser.RhodeCode",
      "stash" => "hudson.plugins.git.browser.Stash",
      "gitlab" => "hudson.plugins.git.browser.GitLab",
    }
  end
end # Cigale::SCM::Git
