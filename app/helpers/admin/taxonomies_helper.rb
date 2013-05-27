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

    nodes.each do |father, children|
      has_children = children.present? ? 'has_children' : ''
      node_html = content_tag :div, class: 'node js_node', data: { node_id: father.id } do
        content_tag :div, class: 'box name' do
          father.name
        end
      end

      if children.present?
        node_html+= raw render_nodes_recursively(children)
      end

      result+= content_tag :div, class: "child #{has_children}" do
        node_html
      end
    end

    raw result
  end

  def render_nodes_recursively(nodes)
    result = ""
    has_children = ""
    node_html = ""

    nodes.each do |node, children|
      has_children = children.present? ? 'has_children' : ''
      node_html += render("admin/taxonomies/node", node: node)

      if children.present?
        node_html+= render_nodes_recursively(children)
      end
    end

    result+= content_tag :div, class: "child #{has_children}" do
      raw node_html
    end

    raw result
  end
end
