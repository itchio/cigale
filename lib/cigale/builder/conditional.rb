
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
      when "files-match"
        xml.includes bdef["include-pattern"].join(",")
        xml.excludes bdef["exclude-pattern"].join(",")

        bdir = bdef["condition-basedir"]
        bdirclass = condition_basedirs[bdir] or raise "Unknown base dir for files-match: '#{bdir}'"
        xml.baseDir :class => bdirclass
      when "file-exists"
        xml.file bdef["condition-filename"]
        bdir = bdef["condition-basedir"]
        bdirclass = condition_basedirs[bdir] or raise "Unknown base dir for file-exists: '#{bdir}'"
        xml.baseDir :class => bdirclass
      when "execution-node"
        xml.allowedNodes do
          for node in bdef["nodes"]
            xml.string node
          end
        end
      when "not"
        translate_condition "condition", xml, bdef["condition-operand"]
      end
    end
  end

  def translate_condition_runner (xml, bdef)
    xml.runner :class => "org.jenkins_ci.plugins.run_condition.BuildStepRunner$Fail"
  end

  def condition_basedirs
    @condition_basedirs ||= {
      "jenkins-home" => "org.jenkins_ci.plugins.run_condition.common.BaseDirectory$JenkinsHome",
      "workspace" => "org.jenkins_ci.plugins.run_condition.common.BaseDirectory$Workspace",
    }
  end

  def condition_classes
    @condition_classes ||= {
      "regex-match" => "org.jenkins_ci.plugins.run_condition.core.ExpressionCondition",
      "files-match" => "org.jenkins_ci.plugins.run_condition.core.FilesMatchCondition",
      "file-exists" => "org.jenkins_ci.plugins.run_condition.core.FileExistsCondition",
      "execution-node" => "org.jenkins_ci.plugins.run_condition.core.NodeCondition",
      "not" => "org.jenkins_ci.plugins.run_condition.logic.Not",
      "and" => "org.jenkins_ci.plugins.run_condition.logic.And",
      "or" => "org.jenkins_ci.plugins.run_condition.logic.Or",
    }
  end

end
