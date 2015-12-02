
module Cigale::Builder
  def translate_sonatype_clm_builder (xml, bdef)
    xml.tag! "com.sonatype.insight.ci.hudson.PreBuildScan", :plugin => "sonatype-clm-ci" do
      xml.billOfMaterialsToken bdef["application-name"]
      xml.failOnClmServerFailures bdef["fail-on-clm-server-failure"]
      xml.stageId bdef["stage"]
      xml.pathConfig do
        xml.scanTargets bdef["scan-targets"]
        xml.moduleExcludes bdef["module-excludes"]
        xml.scanProperties bdef["advanced-options"]
      end
    end
  end
end
