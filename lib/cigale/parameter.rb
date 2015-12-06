
module Cigale::Parameter
  require "cigale/parameter/dynamic-choice"
  require "cigale/parameter/extended-choice"
  require "cigale/parameter/matrix-combinations"
  require "cigale/parameter/node"
  require "cigale/parameter/string"
  require "cigale/parameter/bool"
  require "cigale/parameter/run"

  class CustomParameter
  end

  def parameter_classes
    @parameter_classes ||= {
      "dynamic-choice" => "com.seitenbau.jenkins.plugins.dynamicparameter.ChoiceParameterDefinition",
      "extended-choice" => "com.cwctravel.hudson.plugins.extended__choice__parameter.ExtendedChoiceParameterDefinition",
      "matrix-combinations" => "hudson.plugins.matrix__configuration__parameter.MatrixCombinationsParameterDefinition",
      "node" => "org.jvnet.jenkins.plugins.nodelabelparameter.NodeParameterDefinition",
      "string" => "hudson.model.StringParameterDefinition",
      "bool" => "hudson.model.BooleanParameterDefinition",
      "run" => "hudson.model.RunParameterDefinition",
    }
  end

  # cf. property.rb — params are a different field in jjb but
  # just as much properties for jenkins config
  def translate_parameters_inner (xml, parameters)
    for p in parameters
      type, spec = asplode p
      translate("parameter", xml, type, spec)
    end
  end
end
