
module Cigale::Property
  def translate_heavy_job_property (xml, pdef)
    xml.weight pdef["weight"]
  end
end
