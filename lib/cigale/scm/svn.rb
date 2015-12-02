
module Cigale::SCM
  def translate_svn_scm (xml, sdef)
    if vu = sdef["viewvc-url"]
      xml.browser :class => "hudson.scm.browsers.ViewSVN" do
        xml.url vu
      end
    end

    xml.locations do
      if repos = sdef["repos"]
        for r in repos
          xml.tag! "hudson.scm.SubversionSCM_-ModuleLocation" do
            xml.remote r["url"]
            xml.local r["basedir"] || "."
            if cri = r["credentials-id"]
              xml.credentialsId cri
            end
            xml.depthOption r["repo-depth"] || "infinity"
            xml.ignoreExternalsOption r["ignore-externals"] || false
          end
        end
      else
        xml.tag! "hudson.scm.SubversionSCM_-ModuleLocation" do
          xml.remote sdef["url"]
          xml.local "."
          if cri = sdef["credentials-id"]
            xml.credentialsId cri
          end
          xml.depthOption sdef["repo-depth"] || "infinity"
          xml.ignoreExternalsOption sdef["ignore-externals"] || false
        end
      end
    end # locations

    if upd = sdef["workspaceupdater"]
      uclass = svn_workspace_updaters[upd] or raise "Unknown svn repo updater: #{upd}"
      xml.workspaceUpdater :class => uclass
    end

    if exclRegions = sdef["excluded-regions"]
      xml.excludedRegions exclRegions.join("\n")
    end

    if inclRegions = sdef["included-regions"]
      xml.includedRegions inclRegions.join("\n")
    end

    if exclUsers = sdef["excluded-users"]
      xml.excludedUsers exclUsers.join("\n")
    end

    if exclProp = sdef["exclusion-revprop-name"]
      xml.excludedRevprop exclProp
    end

    if exclCommits = sdef["excluded-commit-messages"]
      xml.excludedCommitMessages exclCommits.join("\n")
    end

    xml.ignoreDirPropChanges sdef["ignore-property-changes-on-directories"] || false
    xml.filterChangelog sdef["filter-changelog"] || false
  end

  def svn_workspace_updaters
    @svn_workspace_updaters ||= {
      "update" => "hudson.scm.subversion.UpdateUpdater",
      "wipeworkspace" => "hudson.scm.subversion.CheckoutUpdater",
    }
  end
end
