
module Cigale::SCM::Svn
  def translate_svn_scm (xml, sdef)
    xml.locations do
      for r in (sdef["repos"] || [])
        xml.tag! "hudson.scm.SubversionSCM_-ModuleLocation" do
          xml.remote r["url"]
          xml.local r["basedir"]
          if cri = r["credentials-id"]
            xml.credentialsId cri
          end
          xml.depthOption r["repo-depth"] || "infinity"
          xml.ignoreExternalsOption r["ignore-externals"] || false
        end
      end
    end # locations

    if sdef["workspaceupdater"]
      xml.workspaceUpdater :class => "hudson.scm.subversion.UpdateUpdater"
      xml.ignoreDirPropChanges false
      xml.filterChangelog false
    end
  end
end
