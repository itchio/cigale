
module Cigale::Wrapper
  def translate_m2_repository_cleanup_wrapper (xml, wdef)
    xml.tag! "hudson.plugins.m2__repo__reaper.M2RepoReaperWrapper", :plugin => "m2-repo-reaper" do

      patterns = (wdef["patterns"] || [])
      if patterns.empty?
        xml.artifactPatterns
        xml.patterns
      else
        xml.artifactPatterns patterns.join(",")

        xml.patterns do
          for pattern in patterns
            xml.string pattern
          end
        end
      end
    end
  end
end
