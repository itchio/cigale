
module Cigale::Builder
  def translate_system_groovy_builder (xml, bdef)
    if cmd = bdef["command"]
      xml.scriptSource :class => "hudson.plugins.groovy.StringScriptSource" do
        xml.command cmd
      end
    elsif file = bdef["file"]
      xml.scriptSource :class => "hudson.plugins.groovy.FileScriptSource" do
        xml.scriptFile file
      end
    end
    xml.bindings bdef["bindings"]
    xml.classpath bdef["class-path"]
  end
end
