
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
    if (triggers || []).size == 0
      return
    end

    xml.triggers :class => "vector" do
      for t in triggers
        ttype = nil
        tdef = nil
        case t
        when String
          ttype = t
        when Hash
          ttype, tdef = first_pair(t)
        end

        clazz = trigger_classes[ttype]
        raise "Unknown trigger type #{ttype}" unless clazz

        xml.tag! clazz do
          xml.spec tdef
        end
      end # for t in triggers
    end # xml.triggers
  end # translate_triggers
end
