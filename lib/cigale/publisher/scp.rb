module Cigale::Publisher
  def translate_scp_publisher (xml, pdef)
    xml.siteName pdef["site"]
    xml.entries do
      for f in pdef["files"]
        xml.tag! "be.certipost.hudson.plugin.Entry" do
          xml.filePath f["target"]
          xml.sourceFile f["source"]
          xml.keepHierarchy f["keep-hierarchy"]
          xml.copyConsoleLog false
          xml.copyAfterFailure f["copy-after-failure"]
        end # Entry
      end # for f in files
    end # entries

  end
end
