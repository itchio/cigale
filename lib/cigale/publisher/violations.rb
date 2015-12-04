module Cigale::Publisher
  def translate_violations_publisher (xml, pdef)
    xml.config
      xml.suppressions :class => "tree-set" do
        xml.tag! "no-comparator"
      end

      xml.typeConfigs do
        xml.tag! "no-comparator"

        %w(checkstyle codenarc cpd cpplint csslint findbugs fxcop gendarme jcreport jslint pep8 perlcritic pmd pylint simian stylecop).each do |type|
          spec = pdef[type] || {}

          xml.entry do
            xml.string type
            xml.tag! "hudson.plugins.violations.TypeConfig" do
              xml.type type
              xml.min spec["min"] || 10
              xml.max spec["max"] || 999
              xml.unstable spec["unstable"] || 999
              if pattern = spec["pattern"]
                xml.usePattern true
                xml.pattern pattern
              else
                xml.usePattern false
                xml.pattern
              end
            end # TypeConfig
          end # entry

        end # %w().each do |type|
      end # typeConfigs

      xml.limit 100
      xml.sourcePathPattern
      xml.fauxProjectPath
      xml.encoding "default"
  end
end
