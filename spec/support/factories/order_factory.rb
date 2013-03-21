FactoryGirl.define do
  factory :order_without_store, class: "Order" do
    ignore do
      total_items 4
    end

    association :shipping_address, factory: :address
    association :user
    environment :website

    # order_item
    after(:create) do |order, evaluator|
      #evaluator.total_items.times { order.items << FactoryGirl.create(:order_item) }n
      4.times do
        item = FactoryGirl.create(:order_item)
        order.items << item
        item.update_quantity(4)
      end
      order.save
    end

    factory :paid_order do
      after(:create) do |order, evaluator|
        order.items.each { |item| item.update_attributes(status: "shipped") }
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
      association :company

      factory :offline_cart do
        environment "offline"
      end
    end
  end
end
