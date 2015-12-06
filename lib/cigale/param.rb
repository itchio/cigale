
module Cigale::Param
  class CustomParam
  end

  def param_classes
    @param_classes ||= {
      "" => ""
    }
  end

  # cf. property.rb — params are a different field in jjb but
  # just as much properties for jenkins config
  def translate_params_inner (xml, params)
    for p in params
      ptype, pdef = asplode(p)
      clazz = param_classes[ptype] or raise "Unknown parameter type #{ptype}"

      method = "translate_#{underize(ptype)}_param"

      case clazz
      when CustomParam
        self.send method, xml, pdef
      else
        xml.tag! clazz do
          self.send method, xml, pdef
        end
      end
    end
  end
end
