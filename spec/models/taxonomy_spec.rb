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
end
