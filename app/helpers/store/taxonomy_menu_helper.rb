module Store::TaxonomyMenuHelper
  def taxonomies_navigation(nodes, level = 1)
    result = ""

    nodes.each do |node, children|
      nodes_html = content_tag :div, class: "node taxonomy_level_#{level}" do
        content_tag :div, class: 'node_container' do
          link_to node.name, ""
        end
      end

      if children.present?
        nodes_html+= raw taxonomies_navigation(children, (level+1))
      end

      if level == 1
        result+= content_tag :div, class: "node_group" do
          nodes_html
        end
      else
        result+= nodes_html
      end
    end

    raw result
  end
end
