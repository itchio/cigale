module Cigale::Publisher
  def translate_email_publisher (xml, pdef)
    xml.recipients pdef["recipients"]
    xml.dontNotifyEveryUnstableBuild false
    xml.sendToIndividuals boolp(pdef["send-to-individuals"], false)
  end
end
