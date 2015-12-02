
module Cigale::Builder

  def translate_ant_builder (xml, bdef)
    case bdef
    when String
      bdef = {"targets" => bdef}
    end

    if buildfile = bdef["buildfile"]
      xml.buildFile buildfile
    end
    if javaopts = bdef["java-opts"]
      xml.antOpts javaopts.join(" ")
    end
    if properties = bdef["properties"]
      content = properties.each_pair.map do |pair|
        "#{pair[0]}=#{pair[1]}\n"
      end.join ""
      xml.properties content
    end
    xml.targets bdef["targets"]
    xml.antName bdef["ant-name"] ||  "default"
  end

end
