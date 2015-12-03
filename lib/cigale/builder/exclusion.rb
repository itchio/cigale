
module Cigale::Builder
  def translate_critical_block_start_builder (xml, bdef)
    xml.tag! "org.jvnet.hudson.plugins.exclusion.CriticalBlockStart", :plugin => "Exclusion"
  end

  def translate_critical_block_end_builder (xml, bdef)
    xml.tag! "org.jvnet.hudson.plugins.exclusion.CriticalBlockEnd", :plugin => "Exclusion"
  end
end
