
module Cigale::Property
  def translate_sidebar_properties (xml, pdefs)
    xml.tag! "hudson.plugins.sidebar__link.ProjectLinks" do
      xml.links do
        for pdef in pdefs
          xml.tag! "hudson.plugins.sidebar__link.LinkAction" do
            xml.url pdef["url"]
            xml.text pdef["text"]
            xml.icon pdef["icon"]
          end
        end
      end
    end
  end
end
