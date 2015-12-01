
module Cigale::SCM::Tfs
  def translate_tfs_scm (xml, sdef)
    xml.serverUrl sdef["server-url"]
    xml.projectPath sdef["project-path"]
    xml.localPath sdef["local-path"]
    xml.workspaceName sdef["workspace"]
    xml.userPassword sdef["password"]
    xml.userName sdef["login"]
    xml.useUpdate sdef["use-update"]

    if sdef.has_key? "web-access"
      wa = sdef["web-access"]
      bclass = "hudson.plugins.tfs.browsers.TeamSystemWebAccessBrowser"

      if wa
        xml.repositoryBrowser :class => bclass do
          for u in (wa || [])
            xml.url u["web-url"]
          end
        end
      else
        xml.repositoryBrowser :class => bclass
      end
    end
  end
end
