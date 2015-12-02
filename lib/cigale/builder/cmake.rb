
module Cigale::Builder

  def translate_cmake_builder (xml, bdef)
    xml.sourceDir bdef["source-dir"]
    xml.buildDir bdef["build-dir"]
    xml.installDir bdef["install-dir"]

    xml.buildType "Debug"
    btype = bdef["build-type"]
    if btype == "Debug"
      xml.otherBuildType
    else
      xml.otherBuildType btype
    end

    xml.generator bdef["generator"] || "Unix Makefiles"
    xml.makeCommand bdef["make-command"] || "make"
    xml.installCommand bdef["install-command"] || "make install"
    xml.preloadScript bdef["preload-script"]
    xml.cmakeArgs bdef["other-arguments"]
    xml.projectCmakePath bdef["custom-cmake-path"]
    xml.cleanBuild bdef["clean-build-dir"]
    xml.cleanInstallDir bdef["clean-install-dir"]
    xml.builderImpl
  end

end
