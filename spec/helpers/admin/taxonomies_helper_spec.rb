require "spec_helper"

describe Admin::TaxonomiesHelper do
  describe ".html_select_collection" do
    let(:node1) { double(id: 1, depth: 0, name: "Node 1") }
    let(:node2) { double(id: 2, depth: 1, name: "Node 2") }
    let(:node3) { double(id: 3, depth: 2, name: "Node 3") }
    let(:taxonomy) { [node1, node2, node3] }

    it "returns an array of taxonomy nodes for using with a html select" do
      collection = helper.html_select_collection(taxonomy)
      collection[0].should == [" Node 1", 1]
      collection[1].should == ["&nbsp;&nbsp;&nbsp; Node 2", 2]
      collection[2].should == ["&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Node 3", 3]
    end
  end
end
