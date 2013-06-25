require 'spec_helper'

describe Taxonomy do
  describe "basic correctness" do
    it "creates parents and children" do
      anakin = Taxonomy.create(name: "Anakin")
      vader  = anakin.children.create(name: "Darth Vader")
      luke   = vader .children.create(name: "Luke")

      luke .parent.should == vader
      vader.parent.should == anakin
    end
  end

  describe ".flat_hash_tree" do
    it "returns a flat array" do
      anakin = Taxonomy.create(name: "Anakin")
      vader  = anakin.children.create(name: "Darth Vader")
      ben    = Taxonomy.create(name: "Ben")
      luke   = vader .children.create(name: "Luke")

      nodes = Taxonomy.flat_hash_tree
      nodes[0].should == anakin
      nodes[1].should == vader
      nodes[2].should == luke
      nodes[3].should == ben
    end
  end

  describe ".search" do
    it "searches for items" do
      item = FactoryGirl.create(:taxonomy, name: "my item")
      Taxonomy.search_for("item").to_a.should include item
      Taxonomy.search_for("taxonomy").to_a.should_not include item
    end
  end
end
