
module Cigale::Wrapper
  def translate_ssh_agent_credentials_wrapper (xml, wdef)
    for user in wdef["users"]
      xml.user user
    end
  end
end
