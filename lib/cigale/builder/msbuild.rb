
module Cigale::Builder
  def translate_msbuild_builder (xml, bdef)
    xml.msBuildName bdef["msbuild-version"]
    xml.msBuildFile bdef["solution-file"]
    xml.cmdLineArgs bdef["extra-parameters"]
    xml.buildVariablesAsProperties bdef["pass-build-variables"]
    xml.continueOnBuildFailure bdef["continue-on-build-failure"]
  end
end
