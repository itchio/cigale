module Cigale::Publisher
  def translate_cloverphp_publisher (xml, pdef)
    if html = pdef["html"]
      xml.publishHtmlReport true
      xml.reportDir html["dir"]
    else
      xml.publishHtmlReport false
    end

    xml.xmlLocation pdef["xml-location"]

    if html
      xml.disableArchiving !html["archive"]
    else
      xml.disableArchiving false
    end

    targets = {}

    for target in toa pdef["metric-targets"]
      k, v = first_pair(target)
      targets[k] = v
    end
    targets["healthy"] ||= {
      "method" => 70,
      "statement" => 80,
    }

    htarget = targets["healthy"]
    utarget = targets["unhealthy"]
    ftarget = targets["failing"]

    xml.healthyTarget do
      hmc = htarget["method"] and xml.methodCoverage hmc
      hsc = htarget["statement"] and xml.statementCoverage hsc
    end

    if utarget
      xml.unhealthyTarget do
        umc = utarget["method"] and xml.methodCoverage umc
        usc = utarget["statement"] and xml.statementCoverage usc
      end
    else
      xml.unhealthyTarget
    end

    if ftarget
      xml.failingTarget do
        fmc = ftarget["method"] and xml.methodCoverage fmc
        fsc = ftarget["statement"] and xml.statementCoverage fsc
      end
    else
      xml.failingTarget
    end
  end
end
