
module Cigale::Property
  def translate_ownership_property (xml, pdef)
    xml.ownership do
      xml.ownershipEnabled true
      xml.primaryOwnerId pdef["owner"]
      xml.coownersIds do
        for co in pdef["co-owners"]
          xml.string co
        end
      end
    end
  end
end
