
module Cigale::Wrapper
  def translate_port_allocator_wrapper (xml, wdef)
    xml.ports do
      names = wdef["names"] || [wdef["name"]]

      for name in names
        xml.tag! "org.jvnet.hudson.plugins.port__allocator.DefaultPortType" do
          xml.name name
        end
      end
    end
  end
end
