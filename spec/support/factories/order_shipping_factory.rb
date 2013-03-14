FactoryGirl.define do
  factory :order_shipping do
    price 40
    service_type  "pac"
    delivery_days 10
    delivery_type "Correios"
  end
end