
module Cigale::Wrapper
  def translate_env_script_wrapper (xml, wdef)
    xml.script wdef["script-content"]
    xml.onlyRunOnParent wdef["only-run-on-parent"]
  end
end
