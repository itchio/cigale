
module Cigale::Publisher
  def translate_naginator_publisher (xml, pdef)
    re = pdef["regular-expression"]
    xml.regexpForRerun re
    xml.checkRegexp !re.nil?

    xml.rerunIfUnstable boolp(pdef["rerun-unstable-builds"], false)

    pinc = pdef["progressive-delay-increment"]
    pmax = pdef["progressive-delay-maximum"]
    if pinc
      xml.delay :class => "com.chikli.hudson.plugin.naginator.ProgressiveDelay" do
        xml.increment pinc
        xml.max pmax
      end
    else
      xml.delay :class => "com.chikli.hudson.plugin.naginator.FixedDelay" do
        xml.delay pdef["fixed-delay"] || 0
      end
    end
    xml.maxSchedule pdef["max-failed-builds"] || 0
  end
end
