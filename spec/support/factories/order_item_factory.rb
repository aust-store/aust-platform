FactoryGirl.define do
  factory :order_item_without_associations, class: "OrderItem" do
    price 13.94
    quantity 1

    factory :order_item do
      after(:build) do |item, evaluator|
        inventory_item = FactoryGirl.create(:inventory_item_without_associations)
        inventory_item.entries << FactoryGirl.build(:inventory_entry,
                                                    store_id: inventory_item.company_id,
                                                    admin_user_id: inventory_item.admin_user_id)
        inventory_item.save
        item.inventory_item  = inventory_item
        item.inventory_entry = inventory_item.entries.first
        item.save
      end
    end
  end
end
