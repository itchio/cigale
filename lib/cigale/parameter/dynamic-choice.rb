module Cigale::Parameter
  def translate_dynamic_choice_parameter (xml, pdef)
    xml.name pdef["name"]
    xml.description pdef["description"]
    xml.__remote pdef["remote"]
    xml.__script pdef["script"]
    xml.__localBaseDirectory :serialization => "custom" do
      xml.tag! "hudson.FilePath" do
        xml.default do
          xml.remote "/var/lib/jenkins/dynamic_parameter/classpath"
        end
        xml.boolean true
      end
    end

    xml.__remoteBaseDirectory "dynamic_parameter_classpath"
    xml.__classPath
    xml.readonlyInputField false
  end
end
