
module Cigale::Wrapper
  def translate_inject_passwords_wrapper (xml, wdef)
    xml.injectGlobalPasswords true
    xml.maskPasswordParameters true
    xml.passwordEntries do
      for pass in wdef["job-passwords"]
        xml.EnvInjectPasswordEntry do
          xml.name pass["name"]
          xml.value pass["password"]
        end
      end
    end
  end
end
