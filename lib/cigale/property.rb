
module Cigale::Property
  class CustomProperty
  end

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
  require "cigale/property/zeromq-event"

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
      "zeromq-event" => "org.jenkinsci.plugins.ZMQEventPublisher.HudsonNotificationProperty",
      "copyartifact" => CustomProperty.new,
    }
  end

  def translate_properties (xml, jdef)
    props = toa jdef["properties"]
    parameters = toa jdef["parameters"]

    if props.empty? && parameters.empty?
      return xml.properties
    end

    xml.properties do
      translate_properties_inner xml, props
      translate_parameters_inner xml, parameters
    end
  end

  def translate_properties_inner (xml, props)
    sidebars = []

    for p in props
      ptype, pdef = asplode(p)
      case ptype
      when "sidebar"
        sidebars << pdef
      else
        clazz = property_classes[ptype]
        raise "Unknown property type: #{ptype}" unless clazz
        method = "translate_#{underize(ptype)}_property"

        case clazz
        when CustomProperty
          self.send method, xml, pdef
        else
          xml.tag! clazz do
            self.send method, xml, pdef
          end
        end
      end
    end # for

    unless sidebars.empty?
      translate_sidebar_properties xml, sidebars
    end
  end
end
