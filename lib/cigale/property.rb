
module Cigale::Property
  require "cigale/property/inject"
  require "cigale/property/least-load"
  require "cigale/property/delivery-pipeline"
  require "cigale/property/ownership"
  require "cigale/property/builds-chain-fingerprinter"
  require "cigale/property/slave-utilization"
  require "cigale/property/sidebar"
  require "cigale/property/authorization"
  require "cigale/property/batch-tasks"
  require "cigale/property/copyartifact"
  require "cigale/property/heavy-job"
  require "cigale/property/throttle"

  def property_classes
    @property_classes ||= {
      "inject" => "EnvInjectJobProperty",
      "least-load" => "org.bstick12.jenkinsci.plugins.leastload.LeastLoadDisabledProperty",
      "delivery-pipeline" => "se.diabol.jenkins.pipeline.PipelineProperty",
      "ownership" => "com.synopsys.arc.jenkins.plugins.ownership.jobs.JobOwnerJobProperty",
      "builds-chain-fingerprinter" => "org.jenkinsci.plugins.buildschainfingerprinter.AutomaticFingerprintJobProperty",
      "slave-utilization" => "com.suryagaddipati.jenkins.SlaveUtilizationProperty",
      "authorization" => "hudson.security.AuthorizationMatrixProperty",
      "batch-tasks" => "hudson.plugins.batch__task.BatchTaskProperty",
      "heavy-job" => "hudson.plugins.heavy__job.HeavyJobProperty",
      "throttle" => "hudson.plugins.throttleconcurrents.ThrottleJobProperty",
    }
  end

  def translate_properties (xml, props)
    if (props || []).size == 0
      return xml.properties
    end

    sidebars = []

    xml.properties do
      for p in props
        case p
        when "delivery-pipeline"
          xml.tag! property_classes[p] do
            xml.stageName
            xml.taskName
          end
          next
        when "zeromq-event"
          xml.tag! "org.jenkinsci.plugins.ZMQEventPublisher.HudsonNotificationProperty" do
            xml.enabled true
          end
          next
        end

        ptype, pdef = first_pair(p)
        clazz = property_classes[ptype]

        unless clazz
          case ptype
          when "sidebar"
            sidebars << pdef
            next
          when "copyartifact"
            translate_copyartifact_property xml, pdef
            next
          else
            raise "Unknown property type: #{ptype}"
          end
        end

        xml.tag! clazz do
          self.send "translate_#{underize(ptype)}_property", xml, pdef
        end
      end # for

      unless sidebars.empty?
        translate_sidebar_properties xml, sidebars
      end
    end
  end

  def boolp (val, default)
    if val.nil?
      default
    else
      val
    end
  end
end
