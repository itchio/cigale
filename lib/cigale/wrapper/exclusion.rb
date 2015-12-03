
module Cigale::Wrapper
  def translate_exclusion_wrapper (xml, wdef)
    xml.tag! "org.jvnet.hudson.plugins.exclusion.IdAllocator", :plugin => "Exclusion" do
      xml.ids do
        for res in wdef["resources"]
          xml.tag! "org.jvnet.hudson.plugins.exclusion.DefaultIdType" do
            xml.name res.upcase
          end
        end
      end
    end
  end
end
