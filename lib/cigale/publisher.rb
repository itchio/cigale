
module Cigale::Publisher
  require "cigale/publisher/aggregate-flow-tests"
  require "cigale/publisher/aggregate-tests"
  require "cigale/publisher/archive"
  require "cigale/publisher/artifact-deployer"
  require "cigale/publisher/blame-upstream"
  require "cigale/publisher/build-publisher"
  require "cigale/publisher/campfire"
  require "cigale/publisher/checkstyle"
  require "cigale/publisher/cifs"
  require "cigale/publisher/cigame"
  require "cigale/publisher/claim-build"
  require "cigale/publisher/clone-workspace"
  require "cigale/publisher/cloverphp"
  require "cigale/publisher/cobertura"
  require "cigale/publisher/conditional-publisher"
  require "cigale/publisher/copy-to-master"
  require "cigale/publisher/coverage"
  require "cigale/publisher/cppcheck"
  require "cigale/publisher/description-setter"
  require "cigale/publisher/disable-failed-job"
  require "cigale/publisher/display-upstream-changes"
  require "cigale/publisher/downstream-ext"
  require "cigale/publisher/doxygen"
  require "cigale/publisher/dry"
  require "cigale/publisher/email-ext"
  require "cigale/publisher/email"
  require "cigale/publisher/emotional-jenkins"
  require "cigale/publisher/findbugs"
  require "cigale/publisher/fingerprint"
  require "cigale/publisher/fitnesse"
  require "cigale/publisher/flowdock"
  require "cigale/publisher/ftp"
  require "cigale/publisher/gatling"
  require "cigale/publisher/git"
  require "cigale/publisher/github-notifier"
  require "cigale/publisher/google-cloud-storage"
  require "cigale/publisher/groovy-postbuild"
  require "cigale/publisher/html-publisher"
  require "cigale/publisher/image-gallery"
  require "cigale/publisher/ircbot"
  require "cigale/publisher/jabber"
  require "cigale/publisher/jacoco"
  require "cigale/publisher/javadoc"
  require "cigale/publisher/jclouds"
  require "cigale/publisher/jira"
  require "cigale/publisher/join-trigger"
  require "cigale/publisher/junit"
  require "cigale/publisher/logparser"
  require "cigale/publisher/logstash"
  require "cigale/publisher/maven-deploy"
  require "cigale/publisher/naginator"
  require "cigale/publisher/performance"
  require "cigale/publisher/pipeline"
  require "cigale/publisher/plot"
  require "cigale/publisher/pmd"
  require "cigale/publisher/post-tasks"
  require "cigale/publisher/postbuildscript"
  require "cigale/publisher/rich-text-publisher"
  require "cigale/publisher/robot"
  require "cigale/publisher/ruby-metrics"
  require "cigale/publisher/s3"
  require "cigale/publisher/scan-build"
  require "cigale/publisher/scoverage"
  require "cigale/publisher/scp"
  require "cigale/publisher/shining-panda"
  require "cigale/publisher/sitemonitor"
  require "cigale/publisher/sloccount"
  require "cigale/publisher/sonar"
  require "cigale/publisher/ssh"
  require "cigale/publisher/stash"
  require "cigale/publisher/tap"
  require "cigale/publisher/testng"
  require "cigale/publisher/text-finder"
  require "cigale/publisher/trigger-parameterized-builds"
  require "cigale/publisher/trigger"
  require "cigale/publisher/valgrind"
  require "cigale/publisher/violations"
  require "cigale/publisher/warnings"
  require "cigale/publisher/workspace-cleanup"
  require "cigale/publisher/xml-summary"
  require "cigale/publisher/xunit"
  require "cigale/publisher/slack"

  class CustomPublisher
  end

  def publisher_classes
    @publisher_classes ||= {
      "aggregate-flow-tests" => CustomPublisher.new,
      "aggregate-tests" => "hudson.tasks.test.AggregatedTestResultPublisher",
      "archive" => "hudson.tasks.ArtifactArchiver",
      "blame-upstream" => CustomPublisher.new,
      "artifact-deployer" => "org.jenkinsci.plugins.artifactdeployer.ArtifactDeployerPublisher",
      "build-publisher" => "hudson.plugins.build__publisher.BuildPublisher",
      "campfire" => "hudson.plugins.campfire.CampfireNotifier",
      "checkstyle" => "hudson.plugins.checkstyle.CheckStylePublisher",
      "cifs" => "jenkins.plugins.publish__over__cifs.CifsPublisherPlugin",
      "cigame" => CustomPublisher.new,
      "claim-build" => CustomPublisher.new,
      "clone-workspace" => CustomPublisher.new,
      "cloverphp" => "org.jenkinsci.plugins.cloverphp.CloverPHPPublisher",
      "cobertura" => "hudson.plugins.cobertura.CoberturaPublisher",
      "conditional-publisher" => "org.jenkins__ci.plugins.flexible__publish.FlexiblePublisher",
      "copy-to-master" => "com.michelin.cio.hudson.plugins.copytoslave.CopyToMasterNotifier",
      "coverage" => "hudson.plugins.cobertura.CoberturaPublisher",
      "cppcheck" => "org.jenkinsci.plugins.cppcheck.CppcheckPublisher",
      "description-setter" => "hudson.plugins.descriptionsetter.DescriptionSetterPublisher",
      "disable-failed-job" => CustomPublisher.new,
      "display-upstream-changes" => CustomPublisher.new,
      "downstream-ext" => "hudson.plugins.downstream__ext.DownstreamTrigger",
      "doxygen" => "hudson.plugins.doxygen.DoxygenArchiver",
      "dry" => "hudson.plugins.dry.DryPublisher",
      "email-ext" => "hudson.plugins.emailext.ExtendedEmailPublisher",
      "email" => "hudson.tasks.Mailer",
      "emotional-jenkins" => CustomPublisher.new,
      "findbugs" => CustomPublisher.new,
      "fingerprint" => "hudson.tasks.Fingerprinter",
      "fitnesse" => "hudson.plugins.fitnesse.FitnesseResultsRecorder",
      "flowdock" => "com.flowdock.jenkins.FlowdockNotifier",
      "ftp" => "jenkins.plugins.publish__over__ftp.BapFtpPublisherPlugin",
      "gatling" => "io.gatling.jenkins.GatlingPublisher",
      "git" => "hudson.plugins.git.GitPublisher",
      "github-notifier" => CustomPublisher.new,
      "google-cloud-storage" => ["com.google.jenkins.plugins.storage.GoogleCloudStorageUploader", :plugin => "google-storage-plugin"],
      "groovy-postbuild" => "org.jvnet.hudson.plugins.groovypostbuild.GroovyPostbuildRecorder",
      "html-publisher" => "htmlpublisher.HtmlPublisher",
      "image-gallery" => "org.jenkinsci.plugins.imagegallery.ImageGalleryRecorder",
      "ircbot" => "hudson.plugins.ircbot.IrcPublisher",
      "jabber" => "hudson.plugins.jabber.im.transport.JabberPublisher",
      "jacoco" => "hudson.plugins.jacoco.JacocoPublisher",
      "javadoc" => "hudson.tasks.JavadocArchiver",
      "jclouds" => "jenkins.plugins.jclouds.blobstore.BlobStorePublisher",
      "jira" => CustomPublisher.new,
      "join-trigger" => "join.JoinTrigger",
      "junit" => "hudson.tasks.junit.JUnitResultArchiver",
      "logparser" => "hudson.plugins.logparser.LogParserPublisher",
      "logstash" => "jenkins.plugins.logstash.LogstashNotifier",
      "maven-deploy" => "hudson.maven.RedeployPublisher",
      "naginator" => "com.chikli.hudson.plugin.naginator.NaginatorPublisher",
      "performance" => "hudson.plugins.performance.PerformancePublisher",
      "pipeline" => "au.com.centrumsystems.hudson.plugin.buildpipeline.trigger.BuildPipelineTrigger",
      "plot" => "hudson.plugins.plot.PlotPublisher",
      "pmd" => "hudson.plugins.pmd.PmdPublisher",
      "post-tasks" => "hudson.plugins.postbuildtask.PostbuildTask",
      "postbuildscript" => "org.jenkinsci.plugins.postbuildscript.PostBuildScript",
      "rich-text-publisher" => "org.korosoft.jenkins.plugin.rtp.RichTextPublisher",
      "robot" => "hudson.plugins.robot.RobotPublisher",
      "ruby-metrics" => "hudson.plugins.rubyMetrics.rcov.RcovPublisher",
      "s3" => "hudson.plugins.s3.S3BucketPublisher",
      "scan-build" => "jenkins.plugins.clangscanbuild.publisher.ClangScanBuildPublisher",
      "scoverage" => "org.jenkinsci.plugins.scoverage.ScoveragePublisher",
      "scp" => "be.certipost.hudson.plugin.SCPRepositoryPublisher",
      "shining-panda" => "jenkins.plugins.shiningpanda.publishers.CoveragePublisher",
      "sitemonitor" => "hudson.plugins.sitemonitor.SiteMonitorRecorder",
      "sloccount" => "hudson.plugins.sloccount.SloccountPublisher",
      "sonar" => "hudson.plugins.sonar.SonarPublisher",
      "ssh" => "jenkins.plugins.publish__over__ssh.BapSshPublisherPlugin",
      "stash" => "org.jenkinsci.plugins.stashNotifier.StashNotifier",
      "tap" => "org.tap4j.plugin.TapPublisher",
      "testng" => "hudson.plugins.testng.Publisher",
      "text-finder" => "hudson.plugins.textfinder.TextFinderPublisher",
      "trigger-parameterized-builds" => "hudson.plugins.parameterizedtrigger.BuildTrigger",
      "trigger" => "hudson.tasks.BuildTrigger",
      "valgrind" => "org.jenkinsci.plugins.valgrind.ValgrindPublisher",
      "violations" => "hudson.plugins.violations.ViolationsPublisher",
      "warnings" => "hudson.plugins.warnings.WarningsPublisher",
      "workspace-cleanup" => ["hudson.plugins.ws__cleanup.WsCleanup", :plugin => "ws-cleanup@0.14"],
      "xml-summary" => "hudson.plugins.summary__report.ACIPluginPublisher",
      "xunit" => "xunit",
      "slack" => ["jenkins.plugins.slack.SlackNotifier", :plugin => "slack@1.8.1"],
    }
  end

  def translate_publishers (xml, tag, publishers)
    publishers = toa publishers
    if publishers.empty?
      return xml.tag! tag
    end

    xml.tag! tag do
      for p in publishers
        type, spec = asplode p
        translate("publisher", xml, type, spec)
      end # for p in publishers
    end

  end # translate_publishers

  def translate_individual_publisher (xml, p)
    type, spec = asplode p

    clazz = publisher_classes[type]

    method = method_for_translate("publisher", type)

    case clazz
    when String
      xml.publisher :class => clazz do
        self.send method, xml, spec
      end
    when Array
      xml.publisher({:class => clazz[0]}.merge(clazz[1])) do
        self.send method, xml, spec
      end
    else
      raise "Invalid individual publisher: #{clazz}"
    end
  end

end
