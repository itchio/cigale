
require_relative "spec_helper"

module Cigale
  describe "ParitySpec" do
    include Helper

    # I don't really suck, but it made implementing everything much easier.
    i_suck_and_my_tests_are_order_dependent!

    [
      "spec/fixtures/parity/yamlparser/fixtures/project-matrix001.yaml"
    ].each do |f|
      it "gens correct xml for '#{f}'" do
        compare_with_xml f, nil
      end
    end

    # Note: fixtures are from jenkins-job-builder but have been tuned to accomodate the following:
    #  - the builder gem doesn't escape '"' as '&quot' in text content (jjb is being overzealous)
    #  - our version of 'raw' doesn't parse & re-generate XML, it just pastes the (indented) text
    #  - tests shouldn't rely on hash key ordering
    #  - some original fixtures lacked a newline at the end of the .xml file
    # Most of these are easy to automate, so it should be relatively straight-forward
    # to keep up with upstream fixtures, should that be desirable.
    # Also, note that the fixtures testing the original templating system aren't
    # tested here either.
    %w(general scm builders properties wrappers publishers).each do |category|
      g = File.join(Helper.fixtures_dir, "parity", category, "**", "*.yaml")
      Dir.glob(g).each do |f|
        # Anything that relies on plugins_info is unimplemented atm.
        next if File.exist?(f.gsub(".yaml", ".plugins_info.yaml"))
        # Don't treat plugins_info files as job description files
        next if f.include? "plugins_info."

        it "gens correct xml for '#{f}'" do
          compare_with_xml f, category
        end
      end
    end

    def compare_with_xml (sample, category)
      Helper.clean_test_dir!
      cdir = File.join(Helper.test_dir, "cig")

      args = []
      if category
        args += ["--test-category", category]
      end
      cigale("test", sample, cdir, args) == 0 or raise "cigale failed"
      xf = Dir.glob(File.join(cdir, "*")).first or raise "no output produced :("

      ref = sample.gsub(/\.yaml$/, ".xml")
      raise "couldn't find reference xml file #{ref}" unless File.exist?(ref)

      0.must_equal diff(xf, ref)
    end
  end
end
