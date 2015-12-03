module Cigale::Publisher
  def translate_clone_workspace_publisher (xml, pdef)
    xml.tag! "hudson.plugins.cloneworkspace.CloneWorkspacePublisher", :plugin => "clone-workspace-scm" do
      xml.workspaceGlob pdef["workspace-glob"]
      weg = pdef["workspace-exclude-glob"] and xml.workspaceExcludeGlob weg
      xml.criteria (pdef["criteria"] || "any").capitalize
      xml.archiveMethod (pdef["archive-method"] || "tar").upcase
      xml.overrideDefaultExcludes boolp(pdef["override-default-excludes"], false)
    end
  end
end
