
module Cigale::Builder
  class CustomCondition
  end

  def translate_conditional_step_builder (xml, bdef)
    case toa(bdef["steps"]).size
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

    if %w(always never).include? ckind
      xml.tag! tag, :class => cclass
    else
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
        when "current-status"
          worst = bdef["condition-worst"] and xml.worstResult do
            translate_build_status xml, worst
          end
          best = bdef["condition-best"] and xml.bestResult do
            translate_build_status xml, best
          end
        when "num-comp"
          xml.lhs bdef["lhs"]
          xml.rhs bdef["rhs"]

          comp = bdef["comparator"]
          cclass = condition_comparator_classes[comp] or raise "Unknown num-comp comparator: #{comp}"
          xml.comparator :class => cclass
        when "build-cause"
          xml.buildCause bdef["cause"]
          xml.exclusiveCause bdef["exclusive-cause"]
        when "strings-match"
          xml.arg1 bdef["condition-string1"]
          xml.arg2 bdef["condition-string2"]
          xml.ignoreCase bdef["condition-case-insensitive"]
        when "time"
          xml.earliestHours bdef["earliest-hour"]
          xml.earliestMinutes bdef["earliest-min"]
          xml.latestHours bdef["latest-hour"]
          xml.latestMinutes bdef["latest-min"]
          xml.useBuildTime bdef["use-build-time"] || false
        when "day-of-week"
          @day_of_week_classes ||= {
            "weekday" => "org.jenkins_ci.plugins.run_condition.core.DayCondition$Weekday",
            "select-days" => "org.jenkins_ci.plugins.run_condition.core.DayCondition$SelectDays",
          }

          dsel = bdef["day-selector"]
          dclass = @day_of_week_classes[dsel] or raise "Unknown day-of-week selector: #{dsel}"

          case dsel
          when "select-days"
            xml.daySelector :class => dclass do
              xml.days do
                %w(SUN MON TUE WED THU FRI SAT).each_with_index do |item, index|
                  xml.tag! "org.jenkins__ci.plugins.run__condition.core.DayCondition_-Day" do
                    xml.day index + 1
                    xml.selected (true == bdef["days"][item]) || false
                  end
                end
              end
            end
          else
            xml.daySelector :class => dclass
          end

          xml.useBuildTime bdef["use-build-time"]
        when "not"
          translate_condition "condition", xml, bdef["condition-operand"]
        when "or", "and"
          operands = bdef["condition-operands"]
          xml.conditions do
            for operand in operands
              xml.tag! "org.jenkins__ci.plugins.run__condition.logic.ConditionContainer" do
                translate_condition "condition", xml, operand
              end
            end
          end
        when "shell"
          xml.command bdef["condition-command"]
        end
      end # xml.tag!
    end # always/never or not
  end

  def condition_comparator_classes
    @condition_comparator_classes ||= {
      "equal" => "org.jenkins_ci.plugins.run_condition.core.NumericalComparisonCondition$EqualTo",
    }
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
      "num-comp" => "org.jenkins_ci.plugins.run_condition.core.NumericalComparisonCondition",
      "execution-node" => "org.jenkins_ci.plugins.run_condition.core.NodeCondition",
      "current-status" => "org.jenkins_ci.plugins.run_condition.core.StatusCondition",
      "build-cause" => "org.jenkins_ci.plugins.run_condition.core.CauseCondition",
      "strings-match" => "org.jenkins_ci.plugins.run_condition.core.StringsMatchCondition",
      "time" => "org.jenkins_ci.plugins.run_condition.core.TimeCondition",
      "day-of-week" => "org.jenkins_ci.plugins.run_condition.core.DayCondition",
      "not" => "org.jenkins_ci.plugins.run_condition.logic.Not",
      "and" => "org.jenkins_ci.plugins.run_condition.logic.And",
      "or" => "org.jenkins_ci.plugins.run_condition.logic.Or",
      "shell" => "org.jenkins_ci.plugins.run_condition.contributed.ShellCondition",
      "always" => "org.jenkins_ci.plugins.run_condition.core.AlwaysRun",
      "never" => "org.jenkins_ci.plugins.run_condition.core.NeverRun",
    }
  end

end
