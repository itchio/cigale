module Cigale::Wrapper
  def translate_workspace_cleanup_wrapper (xml, wdef)
    # cf. publisher/workspace-cleanup.rb
    translate_wscleanup_base xml, wdef

    xml.cleanupParameter wdef["cleanup-parameter"]
    ed = wdef["external-delete"] and xml.externalDelete ed
  end
end
