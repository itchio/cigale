module Cigale::Publisher
  def translate_workspace_cleanup_publisher (xml, pdef)
    translate_wscleanup_base xml, pdef
    xml.cleanupMatrixParent boolp(pdef["cleanup-parent"], false)

    clean = {}
    for c in pdef["clean-if"]
      k, v = first_pair(c)
      clean[k] = v
    end

    xml.cleanWhenSuccess boolp(clean["success"], false)
    xml.cleanWhenUnstable boolp(clean["unstable"], true)
    xml.cleanWhenFailure boolp(clean["failure"], true)
    xml.cleanWhenNotBuilt boolp(clean["not-built"], true)
    xml.cleanWhenAborted boolp(clean["aborted"], true)
    xml.notFailBuild true
  end # translate

  def translate_wscleanup_base (xml, spec)
    xml.patterns do
      %w(include exclude).each do |k|
        for patt in toa(spec[k])
          xml.tag! "hudson.plugins.ws__cleanup.Pattern" do
            xml.pattern patt
            xml.type k.upcase
          end
        end
      end
    end

    xml.deleteDirs boolp(spec["delete-dirs"], false)
  end
end
