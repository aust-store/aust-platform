require 'spec_helper'

describe Store::TaxonomyMenuHelper do
  let(:node) { double(name: "Node") }
  let(:node2) { double(name: "Node 2") }

  describe ".taxonomies_navigation" do
    let(:nodes) { {node => {node => {}, node2 => {}}, node2 => {}} }

    it "returns a taxonomy structure" do
      helper.taxonomies_navigation(nodes)
        .should == '<div class="node_group"><div class="node taxonomy_level_1">' + \
          '<div class="node_container"><a href="">Node</a></div></div><div '     + \
          'class="node taxonomy_level_2"><div class="node_container"><a '        + \
          'href="">Node</a></div></div><div class="node taxonomy_level_2">'      + \
          '<div class="node_container"><a href="">Node 2</a></div></div></div>'  + \
          '<div class="node_group"><div class="node taxonomy_level_1"><div '     + \
          'class="node_container"><a href="">Node 2</a></div></div></div>'
    end
  end
end
