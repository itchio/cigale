
module Cigale::Publisher
  def translate_aggregate_flow_tests_publisher (xml, pdef)
    xml.tag! "org.zeroturnaround.jenkins.flowbuildtestaggregator.FlowTestAggregator"
  end
end
