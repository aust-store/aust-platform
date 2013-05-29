module Admin::TaxonomiesHelper
  def html_select_collection(taxonomy)
    taxonomy.map do |e|
      nesting = ""
      e.depth.times { nesting << "&nbsp;&nbsp;&nbsp;" }
      option_name = "#{nesting} #{e.name}"
      [ raw(option_name), e.id ]
    end
  end

  def render_taxonomies(nodes)
    result = ""
    has_children = ""
    node_html = ""

    nodes.each do |node, children|
      has_children = children.present? ? 'has_children' : ''
      node_html += render("admin/taxonomies/node", node: node)

      if children.present?
        node_html+= raw render_taxonomies(children)
      end

    end
    result+= content_tag :div, class: "child #{has_children}" do
      raw node_html
    end

    raw result
  end
end
