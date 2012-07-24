class InventoryEntry < ActiveRecord::Base; end

require "decorators/admin/inventory_entry_decorator"

shared_examples_for "admin inventory entry decorator contract" do
  subject { Admin::InventoryEntryDecorator }

  it "decorates inventory_entry" do
    expect do
      subject.decorated_collection.should include [
        :inventory_entry
      ]
    end.to_not raise_error
  end

  it "allows description" do
    expect do
      subject.allowed_collection.should == [
        :description, :quantity, :cost_per_unit, :total_quantity, :total_cost,
        :created_at
      ]
    end.to_not raise_error
  end
end
