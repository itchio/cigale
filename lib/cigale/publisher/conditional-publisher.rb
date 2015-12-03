module Cigale::Publisher

  def translate_conditional_publisher_publisher (xml, pdef)
    xml.publishers do

      for publisher in pdef
        xml.tag! "org.jenkins__ci.plugins.flexible__publish.ConditionalPublisher" do
          case publisher["condition-kind"]

          when "current-status"
            xml.condition :class => "org.jenkins_ci.plugins.run_condition.core.StatusCondition" do
              %w(worst best).each do |cond|
                xml.tag! "#{cond}Result" do
                  translate_build_status xml, publisher["condition-#{cond}"]
                end
              end
            end

          when "shell"
            xml.condition :class => "org.jenkins_ci.plugins.run_condition.contributed.ShellCondition" do
              xml.command publisher["condition-command"]
            end

          when "always"
            xml.condition :class => "org.jenkins_ci.plugins.run_condition.core.AlwaysRun"

          end # case condition-type

          onfailure = publisher["on-evaluation-failure"] || "fail"
          verb = case onfailure
          when "dont-run" then "DontRun"
          when "fail" then "Fail"
          when "run-and-mark-unstable" then "RunUnstable"
          else
            raise "Unknown evaluation failure consequence: #{onfailure}"
          end
          xml.runner :class => "org.jenkins_ci.plugins.run_condition.BuildStepRunner$#{verb}"

          for action in publisher["action"]
            translate_individual_publisher xml, action
          end
        end # Conditional publisher
      end # for publisher in pdef
    end
  end # translate

end
