
module Cigale::SCM
  require "cigale/scm/git"
  include Cigale::SCM::Git

  require "cigale/scm/repo"
  include Cigale::SCM::Repo

  require "cigale/scm/tfs"
  include Cigale::SCM::Tfs

  require "cigale/scm/workspace"
  include Cigale::SCM::Workspace

  require "cigale/scm/hg"
  include Cigale::SCM::Hg

  require "cigale/scm/store"
  include Cigale::SCM::Store

  require "cigale/scm/svn"
  include Cigale::SCM::Svn

  def scm_classes
    @scm_classes ||= {
      "nil" => "hudson.scm.NullSCM",
      "git" => "hudson.plugins.git.GitSCM",
      "repo" => "hudson.plugins.repo.RepoScm",
      "tfs" => "hudson.plugins.tfs.TeamFoundationServerScm",
      "workspace" => "hudson.plugins.cloneworkspace.CloneWorkspaceSCM",
      "hg" => "hudson.plugins.mercurial.MercurialSCM",
      "store" => "org.jenkinsci.plugins.visualworks_store.StoreSCM",
      "svn" => "hudson.scm.SubversionSCM"
    }
  end

  def translate_scms (xml, scms, multi=false)
    if scms.nil?
      return xml.scm :class => scm_classes["nil"]
    end

    if scms.size > 1 and not multi
      puts "scms size = #{scms.size}"
      xml.scm :class => "org.jenkinsci.plugins.multiplescms.MultiSCM" do
        xml.scms do
          translate_scms(xml, scms, true)
        end
      end
      return
    end

    for s in scms
      stype, sdef = first_pair(s)

      case stype
      when "raw"
        for l in sdef["xml"].split("\n")
          xml.indent!
          xml << l + "\n"
        end
      else
        clazz = scm_classes[stype]
        raise "Unknown scm type: #{stype}" unless clazz

        xml.scm :class => clazz do
          self.send "translate_#{underize(stype)}_scm", xml, sdef
        end
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