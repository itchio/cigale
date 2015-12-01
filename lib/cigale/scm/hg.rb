
module Cigale::SCM::Hg
  def translate_hg_scm (xml, sdef)
    xml.source sdef["url"]
    xml.revisionType "BRANCH"
    xml.revision "default"
    xml.clean false
    xml.modules
    xml.disableChangeLog false
  end
end
