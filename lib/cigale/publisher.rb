
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
  require "cigale/publisher/maven"
  require "cigale/publisher/naginator"
  require "cigale/publisher/performance"
  require "cigale/publisher/pipeline"
  require "cigale/publisher/plot"
  require "cigale/publisher/pmd"
  require "cigale/publisher/post-tasks"
  require "cigale/publisher/postbuildscript"
  require "cigale/publisher/richtext"
  require "cigale/publisher/robot"
  require "cigale/publisher/ruby-metrics"
  require "cigale/publisher/s3"
  require "cigale/publisher/scan-build"
  require "cigale/publisher/scoverage"
  require "cigale/publisher/scp"
  require "cigale/publisher/shiningpanda"
  require "cigale/publisher/sitemonitor"
  require "cigale/publisher/sloccount"
  require "cigale/publisher/sonar"
  require "cigale/publisher/ssh"
  require "cigale/publisher/stash"
  require "cigale/publisher/tap"
  require "cigale/publisher/testng"
  require "cigale/publisher/text-finder"
  require "cigale/publisher/trigger-parameterized-builds"
  require "cigale/publisher/trigger-success"
  require "cigale/publisher/valgrind"
  require "cigale/publisher/violations"
  require "cigale/publisher/warnings"
  require "cigale/publisher/workspace-cleanup"
  require "cigale/publisher/xml-summary"
  require "cigale/publisher/xunit"

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
      "checkstyle" => "hudson.plugins.checkstyle.CheckStylePublisher",
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
      "emotional-jenkins" => "org.jenkinsci.plugins.emotional__jenkins.EmotionalJenkinsPublisher",
      "findbugs" => CustomPublisher.new,
      "fingerprint" => "hudson.tasks.Fingerprinter",
      "fitnesse" => "hudson.plugins.fitnesse.FitnesseResultsRecorder",
      "flowdock" => "com.flowdock.jenkins.FlowdockNotifier",
      "ftp" => "jenkins.plugins.publish__over__ftp.BapFtpPublisherPlugin",
      "gatling" => "io.gatling.jenkins.GatlingPublisher",
      "git" => "hudson.plugins.git.GitPublisher",
      "github-notifier" => "com.cloudbees.jenkins.GitHubCommitNotifier",
      "google-cloud-storage" => CustomPublisher.new,
      "groovy-postbuild" => "org.jvnet.hudson.plugins.groovypostbuild.GroovyPostbuildRecorder",
      "html-publisher" => "htmlpublisher.HtmlPublisher",
      "image-gallery" => "org.jenkinsci.plugins.imagegallery.ImageGalleryRecorder",
      "ircbot" => "hudson.plugins.ircbot.IrcPublisher",
      "jabber" => "hudson.plugins.jabber.im.transport.JabberPublisher",
      "jacoco" => "hudson.plugins.jacoco.JacocoPublisher",
      "javadoc" => "hudson.tasks.JavadocArchiver",
      "jclouds" => "jenkins.plugins.jclouds.blobstore.BlobStorePublisher",
      "jira" => "hudson.plugins.jira.JiraIssueUpdater",
      "join-trigger" => "join.JoinTrigger",
      "junit" => "hudson.tasks.junit.JUnitResultArchiver",
      "logparser" => "hudson.plugins.logparser.LogParserPublisher",
      "logstash" => "jenkins.plugins.logstash.LogstashNotifier",
      "maven" => "hudson.maven.RedeployPublisher",
      "naginator" => "com.chikli.hudson.plugin.naginator.NaginatorPublisher",
      "performance" => "hudson.plugins.performance.PerformancePublisher",
      "pipeline" => "au.com.centrumsystems.hudson.plugin.buildpipeline.trigger.BuildPipelineTrigger",
      "plot" => "hudson.plugins.plot.PlotPublisher",
      "pmd" => "hudson.plugins.pmd.PmdPublisher",
      "post-tasks" => "hudson.plugins.postbuildtask.PostbuildTask",
      "postbuildscript" => "org.jenkinsci.plugins.postbuildscript.PostBuildScript",
      "richtext" => "org.korosoft.jenkins.plugin.rtp.RichTextPublisher",
      "robot" => "hudson.plugins.robot.RobotPublisher",
      "ruby-metrics" => "hudson.plugins.rubyMetrics.rcov.RcovPublisher",
      "s3" => "hudson.plugins.s3.S3BucketPublisher",
      "scan-build" => "jenkins.plugins.clangscanbuild.publisher.ClangScanBuildPublisher",
      "scoverage" => "org.jenkinsci.plugins.scoverage.ScoveragePublisher",
      "scp" => "be.certipost.hudson.plugin.SCPRepositoryPublisher",
      "shiningpanda" => "jenkins.plugins.shiningpanda.publishers.CoveragePublisher",
      "sitemonitor" => "hudson.plugins.sitemonitor.SiteMonitorRecorder",
      "sloccount" => "hudson.plugins.sloccount.SloccountPublisher",
      "sonar" => "hudson.plugins.sonar.SonarPublisher",
      "ssh" => "jenkins.plugins.publish__over__ssh.BapSshPublisherPlugin",
      "stash" => "org.jenkinsci.plugins.stashNotifier.StashNotifier",
      "tap" => "org.tap4j.plugin.TapPublisher",
      "testng" => "hudson.plugins.testng.Publisher",
      "text-finder" => "hudson.plugins.textfinder.TextFinderPublisher",
      "trigger-parameterized-builds" => "hudson.plugins.parameterizedtrigger.BuildTrigger",
      "trigger-success" => "hudson.tasks.BuildTrigger",
      "valgrind" => "org.jenkinsci.plugins.valgrind.ValgrindPublisher",
      "violations" => "hudson.plugins.violations.ViolationsPublisher",
      "warnings" => "hudson.plugins.warnings.WarningsPublisher",
      "workspace-cleanup" => CustomPublisher.new,
      "xml-summary" => "hudson.plugins.summary__report.ACIPluginPublisher",
      "xunit" => "xunit",
    }
  end

  def translate_publishers (xml, tag, publishers)
    if (publishers || []).size == 0
      return xml.tag! tag
    end

    xml.tag! tag do
      for p in publishers
        ptype, pdef = lookup_publisher(p)
        case ptype
        when "raw"
          for l in pdef["xml"].split("\n")
            xml.indent!
            xml << l + "\n"
          end
        else
          method = "translate_#{underize(ptype)}_publisher"
          clazz = publisher_classes[ptype]
          raise "Unknown publisher type: #{ptype}" unless clazz

          case clazz
          when CustomPublisher
            self.send method, xml, pdef
          else
            xml.tag! clazz do
              self.send method, xml, pdef
            end
          end
        end # not raw
      end # for p in publishers
    end
  end # translate_publishers

  def translate_individual_publisher (xml, p)
    ptype, pdef = lookup_publisher p
    clazz = publisher_classes[ptype]
    raise "Invalid individual publisher: #{clazz}" unless String === clazz

    xml.publisher :class => clazz do
      method = "translate_#{underize(ptype)}_publisher"
      self.send method, xml, pdef
    end
  end

  def lookup_publisher (p)
    ptype = nil
    pdef = {}

    case p
    when Hash
      ptype, pdef = first_pair(p)
    when String
      ptype = p
    else
      raise "Invalid publisher markup: #{p.inspect}"
    end

    return ptype, pdef
  end
end
