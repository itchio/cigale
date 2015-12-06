module Cigale::Publisher
  def translate_copy_to_master_publisher (xml, pdef)
    xml.includes toa(pdef["includes"]).join(",")
    xml.excludes toa(pdef["excludes"]).join(",")
    xml.destinationFolder
  end
end
