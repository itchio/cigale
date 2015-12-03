module Cigale::Publisher
  def translate_copy_to_master_publisher (xml, pdef)
    xml.includes (pdef["includes"] || []).join(",")
    xml.excludes (pdef["excludes"] || []).join(",")
    xml.destinationFolder
  end
end
