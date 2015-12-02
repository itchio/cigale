
module Cigale::Builder::Conditional

  def translate_conditional_step_builder (xml, bdef)
    case (bdef["steps"] || []).size
    when 0
      raise "Need 1 or more steps for conditional: #{bdef.inspect}"
    when 1
      xml.tag! "org.jenkinsci.plugins.conditionalbuildstep.singlestep.SingleConditionalBuilder" do
        translate_conditional_single_step_builder xml, bdef
      end
    else
      xml.tag! "org.jenkinsci.plugins.conditionalbuildstep.ConditionalBuilder" do
        translate_conditional_multi_step_builder xml, bdef
      end
    end
  end

  def translate_conditional_single_step_builder (xml, bdef)
    translate_condition "condition", xml, bdef

    translate_condition_runner xml, bdef

    stype, sdef = first_pair(bdef["steps"].first)
    clazz = builder_classes[stype]
    raise "Unknown builder type: #{stype}" unless clazz

    xml.tag! "buildStep", :class => clazz do
      self.send "translate_#{underize(stype)}_builder", xml, sdef
    end
  end

  def translate_conditional_multi_step_builder (xml, bdef)
    xml.conditionalbuilders do
      for step in bdef["steps"]
        stype, sdef = first_pair(step)
        clazz = builder_classes[stype]
        raise "Unknown builder type: #{stype}" unless clazz

        xml.tag! clazz do
          self.send "translate_#{underize(stype)}_builder", xml, sdef
        end
      end
    end

    translate_condition "runCondition", xml, bdef

    translate_condition_runner xml, bdef
  end

  def translate_condition (tag, xml, bdef)
    ckind = bdef["condition-kind"] || raise("Missing condition-kind: #{bdef.inspect}")
    cclass = condition_classes[ckind]
    raise "Unknown condition kind: #{ckind}" unless cclass

    xml.tag! tag, :class => cclass do
      case ckind
      when "regex-match"
        xml.expression bdef["regex"] || raise("Missing regex: #{bdef.inspect}")
        xml.label bdef["label"] || raise("Missing label: #{bdef.inspect}")
      end
    end
  end

  def translate_condition_runner (xml, bdef)
    xml.runner :class => "org.jenkins_ci.plugins.run_condition.BuildStepRunner$Fail"
  end

  def condition_classes
    @condition_classes ||= {
      "regex-match" => "org.jenkins_ci.plugins.run_condition.core.ExpressionCondition",
    }
  end

end
