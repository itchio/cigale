
module Cigale::Builder
  def builder_classes
    @builder_classes = {
      "inject" => "EnvInjectBuilder",
      "shell" => "hudson.tasks.Shell",
      "batch" => "hudson.tasks.BatchFile",
    }
  end

  def translate_builders (xml, builders)
    if (builders || []).size == 0
      return xml.builders
    end

    xml.builders do
      for b in builders
        btype, bdef = first_pair(b)
        clazz = builder_classes[btype]

        if clazz.nil?
          if btype == "conditional-step"
            translate_conditional_step_builder xml, bdef
          else
            raise "Unknown builder type: #{btype}" unless clazz
          end
        else
          xml.tag! clazz do
            self.send "translate_#{underize(btype)}_builder", xml, bdef
          end
        end
      end
    end
  end

  def translate_inject_builder (xml, bdef)
    xml.info do
      if val = bdef["properties-content"]
        xml.propertiesContent val
      end
    end
  end

  def translate_shell_builder (xml, bdef)
    xml.command bdef
  end

  def translate_batch_builder (xml, bdef)
    xml.command bdef
  end

  def condition_types
    @condition_types = {
      "regex" => "org.jenkins_ci.plugins.run_condition.core.ExpressionCondition",
    }
  end

  def condition_classes
    return @condition_classes = {
      "regex-match" => "org.jenkins_ci.plugins.run_condition.core.ExpressionCondition",
    }
  end

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
end # Cigale::Builder
