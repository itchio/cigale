
module Cigale::Wrapper
  def translate_logstash_wrapper (xml, wdef)
    xml.tag! "jenkins.plugins.logstash.LogstashBuildWrapper", :plugin => "logstash@0.8.0" do
      xml.useRedis wdef["use-redis"]

      if wdef["use-redis"] == true
        redis = (wdef["redis"] || {})
        xml.redis do
          xml.host redis["host"] || "localhost"
          xml.port redis["port"] || 6379
          xml.numb redis["database-number"] || 0
          xml.pass redis["database-password"]
          xml.dataType redis["data-type"] || "list"
          xml.key redis["key"] || "logstash"
        end
      end
    end
  end
end
