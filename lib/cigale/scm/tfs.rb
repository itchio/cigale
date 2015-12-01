
module Cigale::SCM::Tfs
  def translate_tfs_scm (xml, sdef)
    xml.serverUrl sdef["server-url"]
    xml.projectPath sdef["project-path"]
    xml.localPath sdef["local-path"]
    xml.workspaceName sdef["workspace"]
    xml.userPassword sdef["password"]
    xml.userName sdef["login"]
    xml.useUpdate sdef["use-update"]
    if wa = sdef["web-access"]
      xml.repositoryBrowser :class => "hudson.plugins.tfs.browsers.TeamSystemWebAccessBrowser" do
        for u in wa
          xml.url u["web-url"]
        end
      end
    end
  end
end
