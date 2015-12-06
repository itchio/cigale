module Cigale::Parameter
  def translate_matrix_combinations_parameter (xml, pdef)
    xml.name pdef["name"]
    xml.description pdef["description"]
    xml.defaultCombinationFilter pdef["filter"]
  end
end
