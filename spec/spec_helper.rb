require "minitest/spec"
require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use!

require "fileutils"
require "cigale/cli"

module Cigale
  module Helper
    def cigale (cmd, input, output, additional_args=[])
      CLI.new(["-l", "ERROR", "--masquerade", "--fixture", "-o", output, cmd, input] + additional_args)
      0
    end

    def diff (a, b)
      cmd "git diff --exit-code --no-index --color=always #{a} #{b}"
    end

    def cmd (cmd)
      system(cmd) and 0 or $?
    end

    def self.clean_test_dir!
      FileUtils.rm_rf Helper.test_dir
    end

    def self.test_dir
      "./tmp"
    end

    def self.fixtures_dir
      File.join(File.dirname(__FILE__), 'fixtures')
    end
  end
end
