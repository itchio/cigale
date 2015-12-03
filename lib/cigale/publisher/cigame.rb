module Cigale::Publisher
  def translate_cigame_publisher (xml, pdef)
    xml.tag! "hudson.plugins.cigame.GamePublisher"
  end
end
