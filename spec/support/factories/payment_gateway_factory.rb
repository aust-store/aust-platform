FactoryGirl.define do
  factory :payment_gateway do
    email "gateway@example.com"
    token "1234"
    name  "pagseguro"
  end
end
