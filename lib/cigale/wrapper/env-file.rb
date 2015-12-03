
module Cigale::Wrapper
  def translate_env_file_wrapper (xml, wdef)
    xml.filePath wdef["properties-file"]
  end
end
