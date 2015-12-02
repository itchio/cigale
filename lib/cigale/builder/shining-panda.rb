
module Cigale::Builder::ShiningPanda
  def translate_shining_panda_builder (xml, bdef)
    env = bdef["build-environment"]
    bclass = case env
    when "python"
      "jenkins.plugins.shiningpanda.builders.PythonBuilder"
    when "custom"
      "jenkins.plugins.shiningpanda.builders.CustomPythonBuilder"
    when "virtualenv"
      "jenkins.plugins.shiningpanda.builders.VirtualenvBuilder"
    else
      raise "Unknown build environment for shining-panda: #{env}"
    end

    xml.tag! bclass do
      ver = bdef["python-version"] and xml.pythonName ver

      case env
      when "virtualenv", "custom"
        xml.home bdef["name"]
        xml.clear bdef["clear"]
        xml.useDistribute bdef["use-distribute"]
        xml.systemSitePackages bdef["system-site-packages"]
      end

      xml.nature bdef["nature"]
      xml.command bdef["command"]
      xml.ignoreExitCode bdef["ignore-exit-code"]
    end
  end
end
