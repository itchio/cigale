
module Cigale::SCM
  def translate_workspace_scm (xml, sdef)
    xml.parentJobName sdef["parent-job"]
    xml.criteria sdef["criteria"]
  end
end
