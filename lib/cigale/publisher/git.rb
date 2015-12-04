module Cigale::Publisher
  def translate_git_publisher (xml, pdef)
    xml.configVersion 2
    xml.pushMerge pdef["push-merge"]
    xml.pushOnlyIfSuccess pdef["push-only-if-success"]
    xml.forcePush false

    xml.tagsToPush do
      for tag in pdef["tags"]
        tk, tdef = first_pair(tag)

        xml.tag! "hudson.plugins.git.GitPublisher_-TagToPush" do
          xml.targetRepoName tdef["remote"]
          xml.tagName tdef["name"]
          xml.tagMessage tdef["message"]
          xml.createTag tdef["create-tag"]
          xml.updateTag tdef["update-tag"]
        end
      end
    end

    xml.branchesToPush do
      for branch in pdef["branches"]
        btype, bdef = first_pair(branch)
        xml.tag! "hudson.plugins.git.GitPublisher_-BranchToPush" do
          xml.targetRepoName bdef["remote"]
          xml.branchName bdef["name"]
        end
      end
    end

    xml.notesToPush do
      for note in pdef["notes"]
        ntype, ndef = first_pair(note)
        xml.tag! "hudson.plugins.git.GitPublisher_-NoteToPush" do
          xml.targetRepoName ndef["remote"]
          xml.noteMsg ndef["message"]
          xml.noteNamespace ndef["namespace"]
          xml.noteReplace ndef["replace-note"]
        end
      end
    end

  end
end
