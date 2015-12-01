
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

    def compare_with_xml (sample)
      
    end

    g = File.join(Helper.fixtures_dir, "parity", "*.yml")
    Dir.glob(g).each do |f|
      it "do same as jjb '#{f}'" do
        compare_with_jjb f
      end
    end

    g = File.join(Helper.fixtures_dir, "xml", "**", "*.yaml")
    Dir.glob(g).each do |f|
      it "gens correct xml for '#{f}'" do
        compare_with_xml f
      end
    end
  end
end
