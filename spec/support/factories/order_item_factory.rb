FactoryGirl.define do
  factory :order_item_without_associations, class: "OrderItem" do
    price 13.94
    quantity 1

    factory :order_item do

      after(:build) do |item, evaluator|
        entry          = FactoryGirl.attributes_for(:inventory_entry)
        inventory_item = FactoryGirl.create(:inventory_item_without_associations,
                                            entries_attributes: [entry])
        item.inventory_item  = inventory_item
        item.inventory_entry = inventory_item.entries.first
        item.save
      end
    end
  end
end
