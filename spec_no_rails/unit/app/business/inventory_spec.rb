require "./spec_no_rails/spec_helper"

describe Inventory do
  subject { Inventory.new }

  before do
    @product = {id: 1}
    @persistence = double("Persistence")
    @persistence.stub(:persist).and_return(true)
    subject.stub(:persistence_layer).and_return(@persistence)
  end

  context "adding products" do
    it "adds a product" do
      subject.add(@product)
      subject.products.should include(@product)
    end

    it "persist the data" do
      @persistence.should_receive(:persist)
      subject.add(@product).persist
    end
  end

  context "remove a product" do
    before do
      @persistence.stub(:remove).and_return(true)
    end

    it "removes product successfully" do
      @persistence.should_receive(:remove)
      subject.remove(@product)
    end
  end

  describe "#persist" do
    it "calls the persistence layer" do
      subject.should_receive(:persistence_layer).and_return(@persistence)
      subject.persist
    end
  end

  describe "#all" do
    before do
      @persistence.stub(:all).and_return([1, 2, 3])
    end

    it "retrieves all products" do
      @persistence.should_receive(:all).and_return([1, 2, 3])
      subject.all
    end
  end

  describe "#last" do
    before do
      @persistence.stub(:last).and_return([1, 2, 3])
    end

    it "retrieves all products" do
      @persistence.should_receive(:last).and_return(3)
      subject.last
    end
  end
end