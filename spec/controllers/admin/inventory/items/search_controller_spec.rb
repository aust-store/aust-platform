require "spec_helper"

describe Admin::Inventory::Items::SearchController do

  # TODO fix contracts
  #it_obeys_the "InventoryItem model contract"

  before do
    InventoryItem.stub(:search_for).and_return("result")
    subject.stub_chain(:current_customer, :company_id) { 1 }
    subject.stub(:params) { {name: :name} }
  end

  pending "#for_adding_entry" do
    it "should search for items" do
      InventoryItem.should_receive(:search_for).with(:name, 1, page: 1, per_page: 10)
      subject.for_adding_entry
    end

    it "generates the correct route path" do
      subject.should_receive(:new_admin_inventory_item_entry_path)
      subject.for_adding_entry
      subject.path.call(1)
    end
  end

  pending "#index" do
    it "should search for items" do
      InventoryItem.should_receive(:search_for).with(:name, 1, page: 1, per_page: 10)
      subject.index
    end

    it "generates the correct route path" do
      subject.should_receive(:admin_inventory_item_path)
      subject.index
      subject.path.call(1)
    end
  end
end
