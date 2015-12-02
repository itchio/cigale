
module Cigale::Builder
  require "cigale/builder/conditional"
  include Cigale::Builder::Conditional

  require "cigale/builder/inject"
  include Cigale::Builder::Inject

  require "cigale/builder/shell"
  include Cigale::Builder::Shell

  require "cigale/builder/batch"
  include Cigale::Builder::Batch

  require "cigale/builder/gradle"
  include Cigale::Builder::Gradle

  def builder_classes
    @builder_classes = {
      "inject" => "EnvInjectBuilder",
      "shell" => "hudson.tasks.Shell",
      "batch" => "hudson.tasks.BatchFile",
      "gradle" => "hudson.plugins.gradle.Gradle",
    }
  end

  def translate_builders (xml, builders)
    if (builders || []).size == 0
      return xml.builders
    end

    xml.builders do
      for b in builders
        btype, bdef = first_pair(b)
        clazz = builder_classes[btype]

        if clazz.nil?
          if btype == "conditional-step"
            translate_conditional_step_builder xml, bdef
          else
            raise "Unknown builder type: #{btype}" unless clazz
          end
        else
          xml.tag! clazz do
            self.send "translate_#{underize(btype)}_builder", xml, bdef
          end
        end
      end
    end
  end
end # Cigale::Builder
