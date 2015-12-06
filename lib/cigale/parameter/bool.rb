module Cigale::Parameter
  def translate_bool_parameter (xml, pdef)
    xml.name pdef["name"]
    xml.description pdef["description"]
    default = pdef["default"]
    if default.nil? || default == ''
      xml.defaultValue
    else
      xml.defaultValue default
    end
  end
end
