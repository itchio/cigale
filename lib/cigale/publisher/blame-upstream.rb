
module Cigale::Publisher
  def translate_blame_upstream_publisher (xml, pdef)
    xml.tag! "hudson.plugins.blame__upstream__commiters.BlameUpstreamCommitersPublisher"
  end
end
