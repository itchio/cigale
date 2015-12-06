
module Cigale::Trigger
  def trigger_classes
    @trigger_classes ||= {
      "github" => "com.cloudbees.jenkins.GitHubPushTrigger",
      "pollscm" => "hudson.triggers.SCMTrigger",
    }
  end

  class CustomTrigger
  end

  def translate_triggers (xml, triggers)
    triggers = toa triggers
    return if triggers.empty?

    xml.triggers :class => "vector" do
      for t in triggers
        type, spec = asplode t
        translate("trigger", xml, type, spec)
      end
    end
  end # translate_triggers

  def translate_github_trigger (xml, tdef)
    xml.spec tdef
  end

  def translate_pollscm_trigger (xml, tdef)
    xml.spec tdef
  end
end
