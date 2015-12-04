module Cigale::Publisher
  def translate_jclouds_publisher (xml, pdef)
    xml.profileName pdef["profile"]
    xml.entries do
      xml.tag! "jenkins.plugins.jclouds.blobstore.BlobStoreEntry" do
        xml.container pdef["container"]
        xml.path pdef["basedir"]
        xml.sourceFile pdef["Files"]
        xml.keepHierarchy false
      end
    end # entries
  end # translate
end
