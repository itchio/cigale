module Cigale::Publisher
  def translate_xml_summary_publisher (xml, pdef)
    xml.name pdef["files"]
    xml.shownOnProjectPage boolp(pdef["shown-on-project-page"], false)
  end
end
