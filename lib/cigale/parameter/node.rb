module Cigale::Parameter
  def translate_node_parameter (xml, pdef)
    xml.name pdef["name"]
    xml.description pdef["description"]

    ds = toa pdef["default-slaves"]
    if ds.empty?
      xml.defaultSlaves
    else
      xml.defaultSlaves do
        for s in ds
          xml.string s
        end
      end
    end

    as = toa pdef["allowed-slaves"]
    if as.empty?
      xml.allowedSlaves
    else
      xml.allowedSlaves do
        for s in as
          xml.string s
        end
      end
    end

    xml.ignoreOfflineNodes pdef["ignore-offline-nodes"]

    multi = pdef["allowed-multiselect"]
    trigger = if multi
      "allowMultiSelectionForConcurrentBuilds"
    else
      "multiSelectionDisallowed"
    end

    xml.triggerIfResult trigger
    xml.allowMultiNodeSelection multi
    xml.triggerConcurrentBuilds multi
  end
end
