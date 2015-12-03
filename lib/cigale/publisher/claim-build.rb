module Cigale::Publisher
  def translate_claim_build_publisher (xml, pdef)
    xml.tag! "hudson.plugins.claim.ClaimPublisher"
  end
end
