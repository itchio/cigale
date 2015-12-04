module Cigale::Publisher
  def translate_trigger_publisher (xml, pdef)
    xml.childProjects pdef["project"]
    xml.threshold do
      translate_build_status xml, pdef["threshold"], false
    end
  end
end
