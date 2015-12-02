
module Cigale::Wrapper
  def translate_android_emulator_wrapper (xml, wdef)
    xml.osVersion wdef["os"]
    xml.screenDensity "mdpi"
    xml.screenResolution "WVGA"
    xml.deviceLocale "en_US"
    xml.targetAbi wdef["target-abi"]
    xml.sdCardSize wdef["sd-card"]
    xml.hardwareProperties do
      (wdef["hardware-properties"] || {}).each do |key, value|
        xml.tag! "hudson.plugins.android__emulator.AndroidEmulator_-HardwareProperty" do
          xml.key key
          xml.value value
        end
      end
    end
    xml.wipeData wdef["wipe"]
    xml.showWindow wdef["show-window"]
    xml.useSnapshots wdef["snapshot"]
    xml.deleteAfterBuild wdef["delete"]
    xml.startupDelay wdef["startup-delay"]
    xml.commandLineOptions wdef["commandline-options"]
    xml.executable wdef["exe"]
  end
end
