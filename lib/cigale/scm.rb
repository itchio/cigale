
module Cigale::SCM
  require "cigale/scm/git"
  require "cigale/scm/repo"
  require "cigale/scm/tfs"
  require "cigale/scm/workspace"
  require "cigale/scm/hg"
  require "cigale/scm/store"
  require "cigale/scm/svn"

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
    if scms.nil? || scms.size == 0
      return xml.scm :class => scm_classes["nil"]
    end

    if scms.size > 1 and not multi
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

  
end # Cigale::SCM
