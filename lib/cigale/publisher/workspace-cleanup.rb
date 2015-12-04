module Cigale::Publisher
  def translate_workspace_cleanup_publisher (xml, pdef)
    xml.patterns do
      for inc in pdef["include"]
        xml.tag! "hudson.plugins.ws__cleanup.Pattern" do
          xml.pattern inc
          xml.type "INCLUDE"
        end
      end
    end

    xml.deleteDirs false
    xml.cleanupMatrixParent false

    clean = pdef["clean-if"]
    xml.cleanWhenSuccess boolp(clean["success"], false)
    xml.cleanWhenUnstable boolp(clean["unstable"], true)
    xml.cleanWhenFailure boolp(clean["failure"], true)
    xml.cleanWhenNotBuilt boolp(clean["not-built"], true)
    xml.cleanWhenAborted boolp(clean["aborted"], true)
    xml.notFailBuild true
  end
end
