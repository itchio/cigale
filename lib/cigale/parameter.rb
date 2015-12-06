
module Cigale::Parameter
  class CustomParameter
  end

  # require stuff

  def parameter_classes
    @parameter_classes ||= {
      "" => ""
    }
  end

  # cf. property.rb — params are a different field in jjb but
  # just as much properties for jenkins config
  def translate_parameters_inner (xml, params)
    for p in params
      type, spec = asplode p
      translate("parameter", type, spec)
    end
  end
end
