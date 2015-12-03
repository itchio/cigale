
module Cigale::Publisher
  def translate_aggregate_tests_publisher (xml, pdef)
    xml.includeFailedBuilds pdef["include-failed-builds"]
  end
end
