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

  describe "#entry_for_sale" do
    before do
      @good = FactoryGirl.create(:good_with_company)
    end

    it "loads the first entry for sale" do
      entries = @good.balances.all
      @good.entry_for_sale.should == entries.first
      InventoryEntry.first.update_attribute(:on_sale, false)
      @good.entry_for_sale.should == entries.last
    end
  end
end
