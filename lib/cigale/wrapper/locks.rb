
module Cigale::Wrapper
  def translate_locks_wrapper (xml, wdef)
    wdef = toa wdef
    return if wdef.empty?

    xml.tag! "hudson.plugins.locksandlatches.LockWrapper" do
      xml.locks do
        for lock in wdef
          xml.tag! "hudson.plugins.locksandlatches.LockWrapper_-LockWaitConfig" do
            xml.name lock
          end
        end
      end
    end
  end
end
