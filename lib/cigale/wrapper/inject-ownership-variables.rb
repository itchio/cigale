
module Cigale::Wrapper
  def translate_inject_ownership_variables_wrapper (xml, wdef)
    xml.injectNodeOwnership wdef["node-variables"]
    xml.injectJobOwnership wdef["job-variables"]
  end
end
