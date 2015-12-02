
module Cigale::Builder

  def translate_sbt_builder (xml, bdef)
    xml.name bdef["name"]
    xml.jvmFlags bdef["jvm-flags"]
    xml.sbtFlags "-Dsbt.log.noformat=true"
    xml.actions bdef["actions"]
    xml.subdirPath
  end

end
