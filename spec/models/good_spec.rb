require 'spec_helper'

describe Good do
  describe "#search_for" do
    let(:search) { double(search: double(includes: :search)) }

    it "results the correct words by name" do
      Store::ItemsSearch.should_receive(:new).with(Good, :good) { search }

      Good.search_for(:good).should == :search
    end
  end

  describe "#price" do
    let(:item_price) { double }

    it "should delegate to ItemPrice" do
      good = Good.new
      Store::ItemPrice.stub(:new).with(good) { item_price }
      item_price.should_receive(:price)

      good.price
    end
  end
end
