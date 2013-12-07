require 'spec_helper'

describe Store::TaxonomyMenuHelper do
  let(:node) { double(id: 1, name: "Node", to_param: "node_1", slug: "node") }
  let(:node2) { double(id: 2, name: "Node 2", to_param: "node_2", slug: "node-2") }

  describe ".taxonomies_navigation" do
    let(:nodes) { {node => {node => {}, node2 => {}}, node2 => {}} }

    it "returns a taxonomy structure" do
      expected = content_tag(:div, class: "node_group") do
        tag = content_tag(:div, class: "node taxonomy_level_1") do
          content_tag(:div, class: "node_container") do
            link_to "Node", category_path(id: "node_1"), class: "category_1"
          end
        end

        tag+= content_tag(:div, class: "node taxonomy_level_2") do
          content_tag(:div, class: "node_container") do
            link_to "Node", category_path(id: "node_1"), class: "category_1"
          end
        end

        tag+= content_tag(:div, class: "node taxonomy_level_2") do
          content_tag(:div, class: "node_container") do
            link_to "Node 2", category_path(id: "node_2"), class: "category_2 current"
          end
        end

        raw tag
      end

      expected+= content_tag(:div, class: "node_group") do
        tag = content_tag(:div, class: "node taxonomy_level_1") do
          content_tag(:div, class: "node_container") do
            link_to "Node 2", category_path(id: "node_2"), class: "category_2 current"
          end
        end

        raw tag
      end

      helper.taxonomies_navigation(nodes, 2).should == expected
    end
  end
end
