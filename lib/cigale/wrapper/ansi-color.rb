
module Cigale::Wrapper
  def translate_ansi_color_wrapper (xml, wdef)
    xml.colorMapName pdef["color-map"] || "xterm"
  end
end
