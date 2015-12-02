
module Cigale::Property
  def translate_builds_chain_fingerprinter_property (xml, pdef)
    xml.isPerBuildsChainEnabled pdef["per-builds-chain"]
    xml.isPerJobsChainEnabled pdef["per-job-chain"]
  end
end
