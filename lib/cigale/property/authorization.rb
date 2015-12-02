
module Cigale::Property
  def translate_authorization_property (xml, pdef)
    @authorization_classes ||= {
      "job-read" => "hudson.model.Item.Read",
      "job-extended-read" => "hudson.model.Item.ExtendedRead",
    }

    pdef.each do |role, perms|
      for perm in perms
        pclass = @authorization_classes[perm] or raise "Unknown authorization permission: #{perm}"
        xml.permission "#{pclass}:#{role}"
      end
    end
  end
end
