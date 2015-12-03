
module Cigale::Wrapper
  def translate_xvnc_wrapper (xml, wdef)
    xml.takeScreenshot wdef["screenshot"]
    xml.useXauthority wdef["xauthority"]
  end
end
