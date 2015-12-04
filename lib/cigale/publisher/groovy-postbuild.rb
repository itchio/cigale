module Cigale::Publisher
  def translate_groovy_postbuild_publisher (xml, pdef)
    case pdef
    when String
      xml.behavior 0
      xml.groovyScript pdef
    else
      xml.behavior 1
      xml.groovyScript pdef["script"]
    end
  end
end
