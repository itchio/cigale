
require "cgi"

module Cigale::SCM::Repo
  def translate_repo_scm (xml, sdef)
    xml.manifestRepositoryUrl sdef["manifest-url"]
    xml.manifestBranch sdef["manifest-branch"]
    xml.manifestFile sdef["manifest-file"]
    xml.manifestGroup sdef["manifest-group"]
    xml.destinationDir sdef["destination-dir"]
    xml.repoUrl sdef["repo-url"]
    xml.mirrorDir sdef["mirror-dir"]
    xml.jobs sdef["jobs"]
    xml.currentBranch sdef["current-branch"]
    xml.quiet sdef["quiet"]
    xml.indent!
    xml << "<localManifest>" + CGI.escapeHTML(sdef["local-manifest"]) + "</localManifest>\n"
  end
end
