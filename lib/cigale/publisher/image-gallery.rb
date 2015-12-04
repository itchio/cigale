module Cigale::Publisher
  def translate_image_gallery_publisher (xml, pdef)
    xml.imageGalleries do
      for gallery in pdef
        type = gallery["gallery-type"] || "archived-images-gallery"
        clazz = case type
        when "archived-images-gallery"
          "org.jenkinsci.plugins.imagegallery.imagegallery.ArchivedImagesGallery"
        when "in-folder-comparative-gallery"
          "org.jenkinsci.plugins.imagegallery.comparative.InFolderComparativeArchivedImagesGallery"
        when "multiple-folder-comparative-gallery"
          "org.jenkinsci.plugins.imagegallery.comparative.MultipleFolderComparativeArchivedImagesGallery"
        else
          raise "Unknown image gallery type: '#{type}'"
        end

        xml.tag! clazz do
          xml.title gallery["title"]
          imwidth = gallery["image-width"] and xml.imageWidth imwidth
          xml.markBuildAsUnstableIfNoArchivesFound boolp(gallery["unstable-if-no-artifacts"], false)
          baseroot = gallery["base-root-folder"]
          if baseroot || type != "archived-images-gallery"
            xml.baseRootFolder baseroot
          end

          includes = gallery["includes"]
          if includes || type == "archived-images-gallery"
            xml.includes includes
          end
          inwidth = gallery["image-inner-width"] and xml.imageInnerWidth inwidth
        end
      end # for gallery in pdef
    end # xml.imageGalleries
  end # translate

end
