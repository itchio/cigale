
module Cigale::Property
  def translate_batch_tasks_property (xml, pdef)
    xml.tasks do
      for task in pdef
        xml.tag! "hudson.plugins.batch__task.BatchTask" do
          xml.name task["name"]
          xml.script task["script"]
        end
      end
    end
  end
end
