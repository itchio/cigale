
require_relative "minitest_helper"

module Cigale
  describe "ParitySpec" do
    include Helper

    def compare_with_jjb (sample)
      Helper.clean_test_dir!

      jdir = File.join(Helper.test_dir, "jjb")
      jenkins_job(sample, jdir) == 0 or raise "jjb failed"

      cdir = File.join(Helper.test_dir, "cig")
      cigale(sample, cdir) == 0 or raise "cigale failed"

      0.must_equal diff(cdir, jdir)
    end

    g = File.join(Helper.fixtures_dir, "parity", "*.yml")
    Dir.glob(g).each do |f|
      it "be on par for '#{f}'" do
        compare_with_jjb f
      end
    end
  end
end
