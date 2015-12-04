module Cigale::Publisher
  def translate_stash_publisher (xml, pdef)
    xml.stashServerBaseUrl pdef["url"]
    xml.stashUserName pdef["username"]
    xml.stashUserPassword pdef["password"]
    xml.ignoreUnverifiedSSLPeer pdef["ignore-ssl"]
    xml.commitSha1 pdef["commit-sha1"]
    xml.includeBuildNumberInKey pdef["include-build-number"]
  end
end
