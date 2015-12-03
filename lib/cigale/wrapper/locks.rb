
module Cigale::Wrapper
  def translate_locks_wrapper (xml, wdef)
    xml.locks do
      for lock in wdef
        xml.tag! "hudson.plugins.locksandlatches.LockWrapper_-LockWaitConfig" do
          xml.name lock
        end
      end
    end
  end
end
