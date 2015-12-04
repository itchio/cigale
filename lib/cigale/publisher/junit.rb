module Cigale::Publisher
  def translate_junit_publisher (xml, pdef)
    xml.testResults pdef["results"]
    xml.keepLongStdio boolp(pdef["keep-long-stdio"], true)
    xml.healthScaleFactor pdef["health-scale-factor"] || 1.0

    stab = pdef["test-stability"]
    claim = pdef["claim-build"]
    plots = pdef["measurement-plots"]
    if stab || claim || plots
      xml.testDataPublishers do
        stab and xml.tag! "de.esailors.jenkins.teststability.StabilityTestDataPublisher"
        claim and xml.tag! "hudson.plugins.claim.ClaimTestDataPublisher"
        plots and xml.tag! "hudson.plugins.measurement__plots.TestDataPublisher"
      end
    else
      xml.testDataPublishers
    end
  end
end
