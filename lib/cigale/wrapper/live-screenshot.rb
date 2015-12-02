
module Cigale::Wrapper
  def translate_live_screenshot_wrapper (xml, wdef)
    xml.tag! "org.jenkinsci.plugins.livescreenshot.LiveScreenshotBuildWrapper" do
      xml.fullscreenFilename wdef["full-size"] || "screenshot.png"
      xml.thumbnailFilename wdef["thumbnail"] || "screenshot-thumb.png"
    end
  end
end
