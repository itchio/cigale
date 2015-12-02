
module Cigale::Builder

  def translate_cmake_builder (xml, bdef)
    xml.sourceDir bdef["source-dir"]
    xml.buildDir bdef["build-dir"]
    xml.installDir bdef["install-dir"]
    xml.buildType bdef["build-type"]
    xml.otherBuildType
    xml.generator "Unix Makefiles"
    xml.makeCommand "make"
    xml.installCommand "make install"
    xml.preloadScript
    xml.cmakeArgs
    xml.projectCmakePath
    xml.cleanBuild bdef["clean-build-dir"]
    xml.cleanInstallDir bdef["clean-install-dir"]
    xml.builderImpl
  end

end
