
module Cigale::Builder
  def translate_system_groovy_builder (xml, bdef)
    if file = bdef["file"]
      xml.scriptSource :class => "hudson.plugins.groovy.FileScriptSource" do
        xml.scriptFile file
      end
    end
    xml.bindings
    xml.classpath
  end
end
