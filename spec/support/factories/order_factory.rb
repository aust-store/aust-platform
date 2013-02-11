FactoryGirl.define do
  factory :order_without_store do
    association :shipping_address, factory: :address
    association :user

    # order_item
    after(:create) do |order, evaluator|
      order.items << FactoryGirl.create(:order_item)
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
      association :store, factory: :company
    end

    factory :cart, class: "Cart" do
      association :company

      factory :offline_cart do
        environment "offline"
      end
    end
  end
end
