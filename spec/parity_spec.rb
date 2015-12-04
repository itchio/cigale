
require_relative "minitest_helper"

module Cigale
  describe "ParitySpec" do
    include Helper

    i_suck_and_my_tests_are_order_dependent!

    def compare_with_jjb (sample)
      Helper.clean_test_dir!
      jdir = File.join(Helper.test_dir, "jjb")
      cdir = File.join(Helper.test_dir, "cig")

      jenkins_job(sample, jdir) == 0 or raise "jjb failed"
      cigale(sample, cdir) == 0 or raise "cigale failed"

      0.must_equal diff(cdir, jdir)
    end

    def compare_with_xml (sample, category)
      Helper.clean_test_dir!
      cdir = File.join(Helper.test_dir, "cig")

      cigale(sample, cdir, ["--test-category", category]) == 0 or raise "cigale failed"
      xf = Dir.glob(File.join(cdir, "*")).first or raise "no output produced :("

      ref = sample.gsub(/\.yaml$/, ".xml")
      raise "couldn't find reference xml file #{ref}" unless File.exist?(ref)

      0.must_equal diff(xf, ref)
    end

    g = File.join(Helper.fixtures_dir, "parity", "*.yml")
    Dir.glob(g).each do |f|
      it "do same as jjb '#{f}'" do
        compare_with_jjb f
      end
    end

    %w[general scm builders properties wrappers publishers].each do |category|
      g = File.join(Helper.fixtures_dir, "xml", category, "**", "*.yaml")
      Dir.glob(g).each do |f|
        next if f.include? "plugins_info."
        next if File.exist?(f.gsub(".yaml", ".plugins_info.yaml"))
        it "gens correct xml for '#{f}'" do
          compare_with_xml f, category
        end
      end
    end
  end
end
