
module Cigale::Wrapper
  def translate_android_emulator_wrapper (xml, wdef)
    if avd = wdef["avd"]
      xml.avdName avd
    else
      xml.osVersion wdef["os"]
      xml.screenDensity "mdpi"
      xml.screenResolution "WVGA"
      xml.deviceLocale "en_US"
      xml.targetAbi wdef["target-abi"]
      xml.sdCardSize wdef["sd-card"]
    end

    hardprops = (wdef["hardware-properties"] || {})

    if hardprops.empty?
      xml.hardwareProperties
    else
      xml.hardwareProperties do
        hardprops.each do |key, value|
          xml.tag! "hudson.plugins.android__emulator.AndroidEmulator_-HardwareProperty" do
            xml.key key
            xml.value value
          end
        end
      end
    end

    xml.wipeData boolp(wdef["wipe"], false)
    xml.showWindow boolp(wdef["show-window"], false)
    xml.useSnapshots boolp(wdef["snapshot"], false)
    xml.deleteAfterBuild boolp(wdef["delete"], false)
    xml.startupDelay wdef["startup-delay"] || 0
    xml.commandLineOptions wdef["commandline-options"]
    xml.executable wdef["exe"]
  end
end
