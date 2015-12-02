
module Cigale::Builder

  def translate_dsl_builder (xml, bdef)
    if script = bdef["script-text"]
      xml.scriptText script
      xml.usingScriptText true
    elsif target = bdef["target"]
      xml.targets target
      xml.usingScriptText false
    end
    xml.ignoreExisting bdef["ignore-existing"]
    xml.removedJobAction bdef["removed-job-action"]
    xml.removedViewAction bdef["removed-view-action"]
    xml.lookupStrategy bdef["lookup-strategy"]
    xml.additionalClasspath bdef["additional-classpath"]
  end

end
