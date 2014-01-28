FactoryGirl.define do
  factory :order_without_store, class: "Order" do
    ignore do
      total_items 4
    end

    association :shipping_address, factory: :address
    association :customer
    environment :website
    payment_type "cash"

    # order_item
    after(:create) do |order, evaluator|
      # if no items were manually added
      if evaluator.items.blank?
        item = FactoryGirl.create(:order_item)
        order.items << item
        item.update_quantity(evaluator.total_items) if evaluator.total_items > 1
        order.save
      end
    end

    factory :paid_order do
      after(:create) do |order, evaluator|
        order.items.update_all(status: "shipped")
        order.payment_statuses.build(status: :approved, order_id: order.id)
        order.save
      end
    end

    factory :order do
      association :shipping_details, factory: :order_shipping
      association :store, factory: :company
    end

    factory :offline_order do
      association :store, factory: :company
      environment :offline
    end

    factory :cart, class: "Cart" do
      ignore do
        payment_type nil
      end
      association :company

      factory :offline_cart do
        environment "offline"
      end
    end
  end
end
