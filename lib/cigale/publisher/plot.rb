module Cigale::Publisher
  def translate_plot_publisher (xml, pdef)
    xml.plots do
      for plot in pdef
        xml.tag! "hudson.plugins.plot.Plot" do
          if title = plot["title"] and not title.empty?
            xml.title title
          else
            xml.title
          end
          if yaxis = plot["yaxis"] and not yaxis.empty?
            xml.yaxis yaxis
          else
            xml.yaxis
          end
          xml.csvFileName plot["csv-file-name"]

          xml.series do
            for serie in plot["series"]
              case serie["format"]
              when "csv"
                xml.tag! "hudson.plugins.plot.CSVSeries" do
                  xml.file serie["file"]
                  xml.inclusionFlag serie["inclusion-flag"].upcase
                  xml.exclusionValues
                  if url = serie["url"] and not url.empty?
                    xml.url url
                  else
                    xml.url
                  end
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
                xml.tag! "hudson.plugins.plot.XMLSeries" do
                  xml.file serie["file"]
                  if url = serie["url"] and not url.empty?
                    xml.url url
                  else
                    xml.url
                  end
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
          xml.exclZero boolp(plot["exclude-zero-yaxis"], false)
          xml.logarithmic boolp(plot["logarithmic-yaxis"], false)
          xml.keepRecords boolp(plot["keep-records"], false)
          xml.numBuilds
          xml.style plot["style"]
        end # plot
      end # for plot in plots

    end # plots
  end # translate
end
