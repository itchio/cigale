
module Cigale::Wrapper
  def translate_job_log_logger_wrapper (xml, wdef)
    xml.suppressEmpty wdef["suppress-empty"]
  end
end
