module Cigale::Publisher

  def translate_conditional_publisher_publisher (xml, pdef)
    xml.publishers do

      for publisher in pdef
        xml.tag! "org.jenkins__ci.plugins.flexible__publish.ConditionalPublisher" do
          translate_condition "condition", xml, publisher

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
