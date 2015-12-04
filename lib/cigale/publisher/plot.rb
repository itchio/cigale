module Cigale::Publisher
  def translate_plot_publisher (xml, pdef)
    xml.plots do
      for plot in pdef["plot"]
        xml.tag! "hudson.plugins.plot.Plot" do
          xml.title plot["title"]
          xml.yaxis plot["yaxis"]
          xml.csvFileName plot["csv-file-name"]

          xml.series do
            for serie in plot["series"]
              case serie["format"]
              when "csv"
                xml.tag! "hudson.plugins.plot.CSVSeries" do
                  xml.file serie["file"]
                  xml.inclusionFlag serie["inclusion-flag"].upcase
                  xml.exclusionValues
                  xml.url serie["url"]
                  xml.displayTableFlag serie["display-table"]
                  xml.fileType serie["format"]
                end
              when "properties"
                xml.tag! "hudson.plugins.plot.PropertiesSeries" do
                  xml.file serie["file"]
                  xml.label serie["label"]
                  xml.fileType serie["format"]
                end
              when "xml"
                xml.tag! "hudson.plugins.plot.PropertiesSeries" do
                  xml.file serie["file"]
                  xml.url
                  xml.xpathString serie["xpath"]
                  xml.nodeTypeString serie["xpath-type"].upcase
                  xml.fileType serie["format"]
                end
              else
                raise "Unknown serie format for plot: #{serie["format"]}"
              end
            end
          end # series

          xml.group plot["group"]
          xml.useDescr plot["use-description"]
          xml.exclZero false
          xml.logarithmic false
          xml.keepRecords boolp(plot["keep-records"], false)
          xml.numBuilds
          xml.style plot["style"]
        end # plot
      end # for plot in plots

    end # plots
  end # translate
end
