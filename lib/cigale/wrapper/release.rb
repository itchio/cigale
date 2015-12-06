
module Cigale::Wrapper
  def translate_release_wrapper (xml, wdef)
    xml.doNotKeepLog !wdef["keep-forever"]
    xml.overrideBuildParameters false
    xml.releaseVersionTemplate
    xml.parameterDefinitions do
      for param in wdef["parameters"]
        ptype, pspec = asplode param
        translate("parameter", xml, ptype, pspec)
      end
    end

    translate_builders xml, "postSuccessfulBuildSteps", wdef["post-success"]
  end
end
