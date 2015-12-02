
module Cigale::Builder

  def translate_groovy_builder (xml, bdef)
    if cmd = bdef["command"]
      xml.scriptSource :class => "hudson.plugins.groovy.StringScriptSource" do
        xml.command cmd
      end
    elsif file = bdef["file"]
      xml.scriptSource :class => "hudson.plugins.groovy.FileScriptSource" do
        xml.scriptFile file
      end
    end
    xml.groovyName bdef["version"] || "(Default)"
    xml.parameters bdef["parameters"]
    xml.scriptParameters bdef["script-parameters"]
    xml.properties bdef["properties"]
    xml.javaOpts bdef["java-opts"]
    xml.classPath
  end

end
