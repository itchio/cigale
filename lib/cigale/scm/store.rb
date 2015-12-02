
module Cigale::SCM
  def translate_store_scm (xml, sdef)
    xml.scriptName sdef["script"]
    xml.repositoryName sdef["repository"]
    xml.pundles do
      for p in sdef["pundles"]
        xml.tag! "org.jenkinsci.plugins.visualworks_store.PundleSpec" do
          type, name = first_pair(p)
          xml.name name
          xml.pundleType type.upcase
        end
      end
    end
    xml.versionRegex sdef["version-regex"]
    xml.minimumBlessingLevel sdef["minimum-blessing"]
    if pbf = sdef["parcel-builder-file"]
      xml.generateParcelBuilderInputFile true
      xml.parcelBuilderInputFilename pbf
    end
  end
end
