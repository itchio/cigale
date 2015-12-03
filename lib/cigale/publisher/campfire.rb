
module Cigale::Publisher
  def translate_campfire_publisher (xml, pdef)
    if pdef["subdomain"] || pdef["token"] || pdef["ssl"] || pdef["room"]
      xml.campfire do
        xml.subdomain pdef["subdomain"]
        xml.token pdef["token"]
        xml.ssl pdef["ssl"]
      end
      xml.room do
        xml.name pdef["room"]
        xml.campfire :reference => "../../campfire"
      end
    else
      xml.campfire
    end
  end
end
