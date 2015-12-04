module Cigale::Publisher
  def translate_image_gallery_publisher (xml, pdef)
    xml.imageGalleries do
      for gallery in pdef
        clazz = case gallery["gallery-type"]
        when "archived-images-gallery"
          "ArchivedImagesGallery"
        when "in-folder-comparative-gallery"
          "InFolderComparativeArchivedImagesGallery"
        when "multiple-folder-comparative-gallery"
          "MultipleFolderComparativeArchivedImagesGallery"
        else
          raise "Unknown image gallery type: #{gallery["gallery-type"]}"
        end

        xml.tag! "org.jenkinsci.plugins.imagegallery.imagegallery.#{clazz}" do
          xml.title gallery["title"]
          imwidth = gallery["image-width"] and xml.imageWidth imwidth
          xml.markBuildAsUnstableIfNoArchivesFound boolp(gallery["unstable-if-no-artifacts"], false)
          baseroot = gallery["base-root-folder"] and xml.baseRootFolder baseroot
          xml.includes gallery["includes"]
          inwidth = gallery["image-inner-width"] and xml.imageInnerWidth imwidth
        end
      end # for gallery in pdef
    end # xml.imageGalleries
  end # translate

end
