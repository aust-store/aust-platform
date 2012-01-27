require "./spec_no_rails/spec_helper"

describe Inventory do
  before do
    @product = double("Product", id: 1)
    @persistence = double("Persistence")
    @persistence.stub(:add).and_return(true)
    @persistence.stub(:remove).and_return(true)
  end

  context "movement" do
    subject { Inventory.new }

    before do
      subject.stub(:persistence_layer).and_return(@persistence)
    end

    context "adding products" do
      it "adds a product successfully" do
        subject.should_receive(:persistence_layer)
        subject.add(@product).should be_true
      end
    end

    context "removing products" do
      it "removes product successfully" do
        subject.should_receive(:persistence_layer)
        subject.remove(@product).should be_true
      end
    end
  end
end