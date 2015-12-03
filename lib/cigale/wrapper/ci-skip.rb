
module Cigale::Wrapper
  def translate_ci_skip_wrapper (xml, wdef)
    xml.tag! "ruby-proxy-object" do
      xml.tag! "ruby-object", ciskipclass("Jenkins::Tasks::BuildWrapperProxy") do
        xml.pluginid "ci-skip", ciskipclass("String")
        xml.object ciskipclass("CiSkipWrapper") do
          xml.ci__skip ciskipclass("NilClass")
        end
      end
    end
  end

  def ciskipclass (clazz)
    return {
      :pluginid => "ci-skip",
      :"ruby-class" => clazz,
    }
  end
end
