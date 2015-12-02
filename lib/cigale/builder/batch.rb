
module Cigale::Builder::Batch
  def translate_batch_builder (xml, bdef)
    xml.command bdef
  end
end
