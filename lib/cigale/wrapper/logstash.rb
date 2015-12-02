
module Cigale::Wrapper
  def translate_logstash_wrapper (xml, wdef)
    xml.tag! "jenkins.plugins.logstash.LogstashBuildWrapper", :plugin => "logstash@0.8.0" do
      xml.useRedis wdef["use-redis"]
      if redis = wdef["redis"]
        xml.redis do
          xml.host redis["host"]
          xml.port redis["port"]
          xml.numb redis["database-number"]
          xml.pass redis["database-password"]
          xml.dataType redis["data-type"]
          xml.key redis["key"]
        end
      end
    end
  end
end
