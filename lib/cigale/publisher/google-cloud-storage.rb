module Cigale::Publisher
  def translate_google_cloud_storage_publisher (xml, pdef)
    xml.credentialsId pdef["credentials-id"]
    had = {}

    xml.uploads do
      for u in pdef["uploads"]
        k, v = first_pair(u)

        clazz := case k
        when "expiring-elements" then "ExpiringBucketLifecycleManager"
        when "build-log" then "StdoutUpload"
        when "classic" then "ClassicUpload"
        else raise "Unknown upload type #{k}"
        end
        clazz = "com.google.jenkins.plugins.storage.#{clazz}"

        xml.tag! clazz do
          xml.bucketNameWithVars v["bucket-name"]
          xml.sharedPublicly boolp(pdef["share-publicly"], false)
          xml.forFailedJobs boolp(pdef["for-failed-jobs"], false)
          if had[k]
            xml.module :reference => "../../#{clazz}/module"
          else
            xml.module
          end

          case k
          when "expiring-elements" then
            xml.bucketObjectTTL v["days-to-retain"]
          when "build-log" then
            xml.logName v["log-name"]
          when "classic" then
            xml.sourceGlobWithVars v["file-pattern"]
          end
        end

        had[k] = true
      end # for u in uploads

    end
  end
end
