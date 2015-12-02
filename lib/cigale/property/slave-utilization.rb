
module Cigale::Property
  def translate_slave_utilization_property (xml, pdef)
    xml.needsExclusiveAccessToNode (false == pdef["single-instance-per-slave"])
    xml.slaveUtilizationPercentage pdef["slave-percentage"] || 0
    xml.singleInstancePerSlave boolp(pdef["single-instance-per-slave"], false)
  end
end
