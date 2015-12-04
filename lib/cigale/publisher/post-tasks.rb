module Cigale::Publisher
  def translate_post_tasks_publisher (xml, pdef)
    xml.tasks do
      for task in pdef
        xml.tag! "hudson.plugins.postbuildtask.TaskProperties" do
          log_texts = []
          for m in task["matches"]
            if m["log-text"]
              log_texts << m
            end
          end

          xml.logTexts do
            for lt in log_texts
              xml.tag! "hudson.plugins.postbuildtask.LogProperties" do
                xml.logText lt["log-text"]
                xml.operator lt["operator"]
              end
            end
          end

          xml.EscalateStatus task["escalate-status"]
          xml.RunIfJobSuccessful task["run-if-job-successful"]
          xml.script task["script"]
        end # TaskProperties
      end # for task in pdef
    end # xml.tasks
  end # translate
end
