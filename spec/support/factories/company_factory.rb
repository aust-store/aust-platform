FactoryGirl.define do
  factory :company do
    sequence(:name) { |i| "Super Company ##{i}" }
    association :inventory
    sequence(:handle) { |i| "handle_#{i}" }

    after(:create) do |company, evaluator|
      company.build_payment_gateway(email: "gateway@example.com",
                                    token: "1234",
                                    name:  "pagseguro")
      company.save
    end
  end
end
