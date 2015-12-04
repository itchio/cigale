module Cigale::Publisher
  def translate_html_publisher_publisher (xml, pdef)
    xml.reportTargets do
      xml.tag! "htmlpublisher.HtmlPublisherTarget" do
        xml.reportName pdef["name"]
        xml.reportDir pdef["dir"]
        xml.reportFiles pdef["files"]
        xml.keepAll pdef["keep-all"]
        xml.allowMissing pdef["allow-missing"]
        xml.wrapperName "htmlpublisher-wrapper.html"
      end
    end
  end
end
