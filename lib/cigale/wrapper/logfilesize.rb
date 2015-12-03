
module Cigale::Wrapper
  def translate_logfilesize_wrapper (xml, wdef)
    xml.tag! "hudson.plugins.logfilesizechecker.LogfilesizecheckerWrapper", :plugin => "logfilesizechecker" do
      xml.setOwn boolp(wdef["set-own"], false)
      xml.maxLogSize wdef["size"] || 128
      xml.failBuild boolp(wdef["fail"], false)
    end
  end
end
