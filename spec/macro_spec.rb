
require_relative "spec_helper"

module Cigale
  describe "MacroSpec" do
    include Helper

    i_suck_and_my_tests_are_order_dependent!

    # the '.expanded' version
    begin
      g = File.join(Helper.fixtures_dir, "macros", "*.yml")
      Dir.glob(g).each do |f|
        next if f.include? ".expanded"
        it "expands correctly '#{f}'" do
          compare_with_expanded f
        end
      end
    end

    def compare_with_expanded (sample)
      Helper.clean_test_dir!
      cdir = File.join(Helper.test_dir, "cig")

      cigale("dump", sample, cdir) == 0 or raise "cigale failed"
      xf = Dir.glob(File.join(cdir, "*")).first or raise "no output produced :("

      ref = sample.gsub(/\.yml$/, ".expanded.yml")
      raise "couldn't find reference expanded file #{ref}" unless File.exist?(ref)

      0.must_equal diff(xf, ref)
    end
  end
end
