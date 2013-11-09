require 'spec_helper'

describe Store::TaxonomyMenuHelper do
  let(:node) { double(id: 1, name: "Node") }
  let(:node2) { double(id: 2, name: "Node 2") }

  describe ".taxonomies_navigation" do
    let(:nodes) { {node => {node => {}, node2 => {}}, node2 => {}} }

    it "returns a taxonomy structure" do
      expected = content_tag(:div, class: "node_group") do
        tag = content_tag(:div, class: "node taxonomy_level_1") do
          content_tag(:div, class: "node_container") do
            link_to "Node", category_path(id: 1), class: "category_1"
          end
        end

        tag+= content_tag(:div, class: "node taxonomy_level_2") do
          content_tag(:div, class: "node_container") do
            link_to "Node", category_path(id: 1), class: "category_1"
          end
        end

        tag+= content_tag(:div, class: "node taxonomy_level_2") do
          content_tag(:div, class: "node_container") do
            link_to "Node 2", category_path(id: 2), class: "category_2"
          end
        end

        raw tag
      end

      expected+= content_tag(:div, class: "node_group") do
        tag = content_tag(:div, class: "node taxonomy_level_1") do
          content_tag(:div, class: "node_container") do
            link_to "Node 2", category_path(id: 2), class: "category_2"
          end
        end

        raw tag
      end

      helper.taxonomies_navigation(nodes).should == expected
    end
  end
end
