module Cigale::Publisher
  def translate_postbuildscript_publisher (xml, pdef)
    if builders = pdef["builders"]
      translate_builders xml, "buildSteps", builders
    end

    if generic = pdef["generic-script"]
      xml.genericScriptFileList do
        for e in generic
          xml.tag! "org.jenkinsci.plugins.postbuildscript.GenericScript" do
            xml.filePath e
          end
        end
      end
    end

    if groovyscript = pdef["groovy-script"]
      xml.groovyScriptFileList do
        for e in groovyscript
          xml.tag! "org.jenkinsci.plugins.postbuildscript.GroovyScriptFile" do
            xml.filePath e
          end
        end
      end
    end

    if groovy = pdef["groovy"]
      xml.groovyScriptContentList do
        for e in groovy
          xml.tag! "org.jenkinsci.plugins.postbuildscript.GroovyScriptContent" do
            xml.content e
          end
        end
      end
    end

    xml.scriptOnlyIfSuccess boolp(pdef["script-only-if-succeeded"], true)
    xml.scriptOnlyIfFailure boolp(pdef["script-only-if-failed"], false)

    on = pdef["execute-on"] and xml.executeOn on.upcase
  end
end
