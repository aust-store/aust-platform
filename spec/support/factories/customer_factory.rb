FactoryGirl.define do
  factory :customer do
    ignore do
      create_address true
    end

    sequence(:email) { |n| "customer#{n}@example.com" }
    sequence(:first_name) { |n| "The Tick#{n}" }
    sequence(:last_name) { |n| "Holycowjohnson#{n}" }
    password "123456"
    password_confirmation "123456"
    social_security_number "141.482.543-93"

    home_number        "11111111"
    home_area_number   "53"
    mobile_number      "22222222"
    mobile_area_number "54"
    work_number        "33333333"
    work_area_number   "55"

    association :store, factory: :company

    # address
    after(:create) do |customer, evaluator|
      if evaluator.create_address
        customer.addresses.build(FactoryGirl.attributes_for(:address))
        customer.save
      end
    end
  end
end
