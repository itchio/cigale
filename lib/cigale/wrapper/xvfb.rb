
module Cigale::Wrapper
  def translate_xvfb_wrapper (xml, wdef)
    xml.installationName wdef["installation-name"] || "default"
    xml.autoDisplayName boolp(wdef["auto-display-name"], false)
    xml.displayName wdef["display-name"]
    xml.assignedLabels wdef["assigned-labels"]
    xml.parallelBuild boolp(wdef["parallel-builds"], false)
    xml.timeout wdef["timeout"] || 0
    xml.screen wdef["screen"] || "1024x768x16"
    xml.displayNameOffset wdef["display-name-offset"] || 1
    xml.additionalOptions wdef["additional-options"]
    xml.debug boolp(wdef["debug"], false)
    xml.shutdownWithBuild boolp(wdef["shutdown-with-build"], false)
  end
end
