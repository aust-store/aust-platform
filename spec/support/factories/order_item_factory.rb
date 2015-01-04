FactoryGirl.define do
  factory :order_item_without_associations, class: "OrderItem" do
    price 13.94
    price_for_installments 17.94
    quantity 1

    factory :order_item do
      after(:build) do |item, evaluator|
        inventory_item = FactoryGirl.create(:inventory_item)
        entry = FactoryGirl.create(:inventory_entry,
                                   store_id: inventory_item.company_id,
                                   admin_user_id: inventory_item.admin_user_id,
                                   inventory_item_id: inventory_item.id)
        item.inventory_entry = entry
        item.inventory_item = inventory_item
        item.save
      end

      factory :cart_item do

      end
    end
  end
end
