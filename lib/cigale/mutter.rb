
require "pp" # pretty-print

module Cigale
  # Crappy logger to help me debug this macro mess - amos
  class Mutter
    def mutt (msg, obj)
      puts "--------------------"
      puts "> #{msg}: "
      puts
      pp obj
      puts "--------------------"
    end

    def matt
      puts
      puts "==============================="
      puts
    end
  end
end
