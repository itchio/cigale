module Cigale::Publisher
  def translate_display_upstream_changes_publisher (xml, pdef)
    xml.tag! "jenkins.plugins.displayupstreamchanges.DisplayUpstreamChangesRecorder"
  end
end
