module Cigale::Parameter
  def translate_extended_choice_parameter (xml, pdef)
    xml.name pdef["name"]
    xml.description pdef["description"]
    xml.value pdef["value"]
    xml.visibleItemCount pdef["visible-item-count"] || 2
    xml.multiSelectDelimiter pdef["multi-select-delimiter"] || ","
    xml.quoteValue boolp(pdef["quote-value"], false)
    xml.defaultValue pdef["default-value"]
    type = pdef["type"]
    unless type.start_with? "PT_"
      type = "pt-#{type}".gsub("-", "_").upcase
    end
    xml.type type
    xml.propertyFile pdef["property-file"]
    xml.propertyKey pdef["property-key"]
    xml.defaultPropertyFile pdef["default-property-file"]
    xml.defaultPropertyKey pdef["default-property-key"]
  end
end
