
module Cigale::Builder

  def translate_beaker_builder (xml, bdef)
    if path = bdef["path"]
      xml.jobSource :class => "org.jenkinsci.plugins.beakerbuilder.FileJobSource" do
        xml.jobPath path
      end
    elsif content = bdef["content"]
      xml.jobSource :class => "org.jenkinsci.plugins.beakerbuilder.StringJobSource" do
        xml.jobContent content
      end
    end
    xml.downloadFiles !!bdef["download-logs"]
  end

end
