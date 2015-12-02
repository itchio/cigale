
module Cigale::Property
  def translate_delivery_pipeline_property (xml, pdef)
    xml.stageName pdef["stage"]
    xml.taskName pdef["task"]
  end
end
