
module Cigale::Wrapper
  def translate_ssh_agent_credentials_wrapper (xml, wdef)
    users = wdef["users"] || [wdef["user"]]
    if users.size > 1
      xml.credentialIds do
        for user in users
          xml.string user
        end
      end
    else
      for user in users
        xml.user user
      end
    end
  end
end
