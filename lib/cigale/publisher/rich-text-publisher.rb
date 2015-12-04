module Cigale::Publisher
  def translate_rich_text_publisher_publisher (xml, pdef)
    xml.stableText pdef["stable-text"]
    xml.unstableText pdef["unstable-text"]
    xml.failedText pdef["failed"]
    xml.unstableAsStable (not pdef.has_key?("unstable-text"))
    xml.failedAsStable true
    xml.parserName pdef["parser-name"]
  end
end
