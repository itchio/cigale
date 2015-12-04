module Cigale::Publisher
  def translate_s3_publisher (xml, pdef)
    xml.profileName pdef["s3-profile"]

    xml.entries do
      for e in pdef["entries"]
        xml.tag! "hudson.plugins.s3.Entry" do
          xml.bucket e["destination-bucket"]
          xml.sourceFile e["source-files"]
          xml.storageClass e["storage-class"]
          xml.selectedRegion e["bucket-region"]
          xml.noUploadOnFailure !e["upload-on-failure"]
          xml.uploadFromSlave e["upload-from-slave"]
          xml.managedArtifacts e["managed-artifacts"]
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
