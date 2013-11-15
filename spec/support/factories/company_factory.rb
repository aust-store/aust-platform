FactoryGirl.define do
  factory :company do
    sequence(:name) { |i| "Super Company ##{i}" }
    association :contact
    association :theme
    association :inventory
    association :settings, factory: :company_setting
    sequence(:handle) { |i| "handle#{i}" }
    sequence(:domain) { |i| "petshop#{i}.com" }

    after(:create) do |company, evaluator|
      company.build_payment_gateway(email: "gateway@example.com",
                                    token: "1234",
                                    name:  "pagseguro")
      company.save
    end

    trait :minimalism_theme do
      association :theme, :minimalism
    end

    factory :company_with_zipcode do
      association :settings, factory: :company_setting
    end
  end
end
