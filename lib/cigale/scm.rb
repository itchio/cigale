
module Cigale::SCM
  require "cigale/scm/git"
  include Cigale::SCM::Git

  require "cigale/scm/repo"
  include Cigale::SCM::Repo

  def scm_classes
    @scm_classes ||= {
      "nil" => "hudson.scm.NullSCM",
      "git" => "hudson.plugins.git.GitSCM",
      "repo" => "hudson.plugins.repo.RepoScm"
    }
  end

  def translate_scms (xml, scms)
    if scms.nil?
      return xml.scm :class => scm_classes["nil"]
    end

    for s in scms
      stype, sdef = first_pair(s)
      clazz = scm_classes[stype]
      raise "Unknown scm type: #{stype}" unless clazz

      xml.scm :class => clazz do
        self.send "translate_#{underize(stype)}_scm", xml, sdef
      end
    end
  end

  def translate_triggers (xml, triggers)
    if (triggers || []).size == 0
      return
    end

    xml.triggers :class => "vector" do
      for t in triggers
        case t
        when "github"
          xml.tag! "com.cloudbees.jenkins.GitHubPushTrigger" do
            xml.spec
          end
        else
          raise "Unknown trigger type: #{t}"
        end
      end
    end
  end
end # Cigale::SCM
