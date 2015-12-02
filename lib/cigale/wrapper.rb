
module Cigale::Wrapper
  require "cigale/wrapper/timeout"

  def wrapper_classes
    @wrapper_classes ||= {
      "timeout" => "hudson.plugins.build__timeout.BuildTimeoutWrapper",
    }
  end

  def translate_wrappers (xml, wrappers)
    if (wrappers || []).size == 0
      return xml.buildWrappers
    end

    xml.buildWrappers do
      for w in wrappers
        wtype, wdef = first_pair(w)
        clazz = wrapper_classes[wtype]

        if clazz
          xml.tag! clazz do
            self.send "translate_#{underize(wtype)}_wrapper", xml, wdef
          end
        else
          raise "Unknown wrapper type: #{wtype}"
        end # unless clazz

      end # for w in wrappers
    end # wrappers
  end
end
