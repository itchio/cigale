
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
  require "cigale/publisher/copy-to-mater"
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
      "blame-upstream" => CustomPublisher.new,

      "naginator" => "com.chikli.hudson.plugin.naginator.NaginatorPublisher",
      "aggregate-tests" => "hudson.tasks.test.AggregatedTestResultPublisher",
      "archive" => "hudson.tasks.ArtifactArchiver",
      "artifact-deployer" => "org.jenkinsci.plugins.artifactdeployer.ArtifactDeployerPublisher",
      "build-publisher" => "hudson.plugins.build__publisher.BuildPublisher",
      "campfire" => "hudson.plugins.campfire.CampfireNotifier",
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
