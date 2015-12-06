module Cigale::Parameter
  def translate_run_parameter (xml, pdef)
    xml.name pdef["name"]
    xml.description pdef["description"]
    xml.projectName pdef["project-name"]
  end
end
