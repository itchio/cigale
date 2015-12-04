module Cigale::Publisher
  def translate_fitnesse_publisher (xml, pdef)
    xml.fitnessePathToXmlResultsIn pdef["results"]
  end
end
