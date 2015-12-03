module Cigale::Publisher
  def translate_description_setter_publisher (xml, pdef)
    xml.regexp pdef["regexp"]
    xml.regexpForFailed pdef["regexp-for-failed"]
    xml.description pdef["description"]
    xml.descriptionForFailed pdef["description-for-failed"]
    xml.setForMatrix pdef["set-for-matrix"]
  end
end
