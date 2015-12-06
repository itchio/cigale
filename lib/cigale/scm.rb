
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
    scms = toa scms
    if scms.empty?
      return xml.scm :class => scm_classes["nil"]
    end

    if scms.size > 1 and not multi
      return xml.scm :class => "org.jenkinsci.plugins.multiplescms.MultiSCM" do
        xml.scms do
          translate_scms(xml, scms, true)
        end
      end
    end

    for s in scms
      type, spec = asplode s

      case type
      when "raw"
        insert_raw xml, spec
      else
        clazz = scm_classes[type]
        raise "Unknown scm type: #{type}" unless clazz

        method = method_for_translate("scm", type)

        xml.scm :class => clazz do
          self.send method, xml, spec
        end
      end
    end
  end


end # Cigale::SCM
