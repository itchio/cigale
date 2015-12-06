module Cigale::Publisher
  def translate_s3_publisher (xml, pdef)
    xml.profileName pdef["s3-profile"]

    xml.entries do
      for e in pdef["entries"]
        xml.tag! "hudson.plugins.s3.Entry" do
          xml.bucket e["destination-bucket"]
          xml.sourceFile e["source-files"]
          xml.storageClass e["storage-class"] || "STANDARD"
          xml.selectedRegion e["bucket-region"] || "us-east-1"
          xml.noUploadOnFailure boolp(!e["upload-on-failure"], true)
          xml.uploadFromSlave boolp(e["upload-from-slave"], false)
          xml.managedArtifacts boolp(e["managed-artifacts"], false)
        end
      end
    end # entries

    xml.userMetadata do
      for tag in pdef["metadata-tags"]
        xml.tag! "hudson.plugins.s3.MetadataPair" do
          xml.key tag["key"]
          xml.value tag["value"]
        end
      end
    end # userMetadata

  end # translate
end
