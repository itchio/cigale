
module Cigale::Wrapper
  def translate_credentials_binding_wrapper (xml, wdef)
    @credentials_binding_classes ||= {
      "zip-file" => "org.jenkinsci.plugins.credentialsbinding.impl.ZipFileBinding",
      "file" => "org.jenkinsci.plugins.credentialsbinding.impl.FileBinding",
      "username-password" => "org.jenkinsci.plugins.credentialsbinding.impl.UsernamePasswordBinding",
      "username-password-separated" => "org.jenkinsci.plugins.credentialsbinding.impl.UsernamePasswordMultiBinding",
      "text" => "org.jenkinsci.plugins.credentialsbinding.impl.StringBinding",
    }

    xml.bindings do
      for binding in (wdef || [])
        k, v = first_pair(binding)
        clazz = @credentials_binding_classes[k] or raise "Unknown credentials binding class: #{k}"

        xml.tag! clazz do
          case k
          when "username-password-separated"
            xml.usernameVariable v["username"]
            xml.passwordVariable v["password"]
          else
            xml.variable v["variable"]
          end
          xml.credentialsId v["credential-id"]
        end
      end
    end
  end
end
