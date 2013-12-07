module Store::TaxonomyMenuHelper
  def taxonomies_navigation(nodes, current_category = nil, level = 1)
    result = ""

    nodes.each do |node, children|
      nodes_html = content_tag :div, class: "node taxonomy_level_#{level}" do
        content_tag :div, class: 'node_container' do
          css_class = []
          css_class << "category_#{node.id}"
          if current_category.present? && [node.id.to_s, node.slug].include?(current_category.to_s)
            css_class << "current"
          end
          link_to node.name, category_path(node), class: "#{css_class.join(" ")}"
        end
      end

      if children.present?
        nodes_html+= raw taxonomies_navigation(children, current_category, (level+1))
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
