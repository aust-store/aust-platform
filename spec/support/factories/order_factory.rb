FactoryGirl.define do
  factory :order do
    association :shipping_address, factory: :address
    association :user
    association :store, factory: :company

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

  end

  factory :cart, class: "Cart" do
  end
end
