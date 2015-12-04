module Cigale::Publisher
  def translate_text_finder_publisher (xml, pdef)
    xml.fileSet pdef["fileset"]
    xml.regexp pdef["regexp"]
    xml.alsoCheckConsoleOutput pdef["also-check-console-output"]
    xml.succeedIfFound pdef["succeed-if-found"]
    xml.unstableIfFound pdef["unstable-if-found"]
  end
end
