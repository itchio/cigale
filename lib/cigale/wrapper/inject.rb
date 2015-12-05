
module Cigale::Wrapper
  def translate_inject_wrapper (xml, wdef)
    xml.info do
      val = wdef["properties-file-path"] and xml.propertiesFilePath val
      val = wdef["properties-content"] and xml.propertiesContent val
      val = wdef["script-file-path"] and xml.scriptFilePath val
      val = wdef["script-content"] and xml.scriptContent val
      val = wdef["groovy-script-content"] and xml.groovyScriptContent val
      xml.loadFilesFromMaster boolp(wdef["load-files-from-master"], false)
    end
  end
end
