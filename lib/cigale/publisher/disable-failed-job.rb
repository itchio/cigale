module Cigale::Publisher
  def translate_disable_failed_job_publisher (xml, pdef)
    xml.tag! "disableFailedJob.disableFailedJob.DisableFailedJob", :plugin => "disable-failed-job" do
      xml.whenDisable pdef["when-to-disable"]
      times = pdef["no-of-failures"] and xml.failureTimes times
      xml.optionalBrockChecked !!times
    end
  end
end
