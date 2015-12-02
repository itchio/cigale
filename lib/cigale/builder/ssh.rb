
module Cigale::Builder
  # sigh...
  def translate_ssh_builder_builder (xml, bdef)
    xml.siteName bdef["ssh-user-ip"]
    xml.command bdef["command"]
  end
end
