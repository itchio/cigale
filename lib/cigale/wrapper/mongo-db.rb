
module Cigale::Wrapper
  def translate_mongo_db_wrapper (xml, wdef)
    xml.tag! "org.jenkinsci.plugins.mongodb.MongoBuildWrapper", :plugin => "mongodb" do
      xml.mongodbName wdef["name"]
      xml.port wdef["port"]
      xml.dbpath wdef["data-directory"]
      xml.parameters wdef["startup-params"]
      xml.startTimeout wdef["start-timeout"]
    end
  end
end
