module Cigale::Publisher
  def translate_sitemonitor_publisher (xml, pdef)
    xml.mSites do
      for site in pdef["sites"]
        xml.tag! "hudson.plugins.sitemonitor.model.Site" do
          xml.mUrl site["url"]
        end
      end # for site
    end # xml.mSites
  end
end
