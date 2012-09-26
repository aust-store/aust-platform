require "store/inventory_item_creation"

describe Store::InventoryItemCreation do
  let(:controller) { double(current_user: user, current_company: company) }
  let(:user)       { double(id: 2) }
  let(:company)    { double }

  describe "#create" do
    let(:item) { double(save: :saved) }

    it "creates an item" do
      item.should_receive(:new).with(id: 1, user: user) { item }
      company.stub(:items) { item }

      creation = Store::InventoryItemCreation.new(controller)
      creation.create({id: 1})
    end

    it "returns the save status" do
      company.stub_chain(:items, :new) { item }
      creation = Store::InventoryItemCreation.new(controller)
      creation.create({}).should == :saved
    end
  end

  describe "#active_record_item" do
    let(:item) { double(save: :saved) }

    it "returns an Active Record instance" do
      company.stub_chain(:items, :new) { item }
      creation = Store::InventoryItemCreation.new(controller)
      creation.create({})
      creation.active_record_item.should == item
    end
  end
end
