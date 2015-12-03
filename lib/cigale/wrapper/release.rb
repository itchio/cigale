
module Cigale::Wrapper
  def translate_release_wrapper (xml, wdef)
    @hudson_parameter_types ||= {
      "string" => "hudson.model.StringParameterDefinition",
      "bool" => "hudson.model.BooleanParameterDefinition",
    }

    xml.doNotKeepLog !wdef["keep-forever"]
    xml.overrideBuildParameters false
    xml.releaseVersionTemplate
    xml.parameterDefinitions do
      for param in wdef["parameters"]
        pk, pv = first_pair(param)
        pclass = @hudson_parameter_types[pk] or raise "Unknown release parameter type #{pk}"
        xml.tag! pclass do
          xml.name pv["name"]
          xml.description pv["description"]
          default = pv["default"]
          if default.nil? || default == ''
            xml.defaultValue
          else
            xml.defaultValue default
          end
        end
      end
    end

    translate_builders xml, "postSuccessfulBuildSteps", wdef["post-success"]
  end
end
