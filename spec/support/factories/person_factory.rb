FactoryGirl.define do
  factory :barebone_person, class: "Person" do
    transient do
      create_address true
      customer true
      supplier false
    end

    sequence(:first_name) { |n| "The Tick#{n}" }
    environment "admin"

    factory :person, class: "Person" do

      sequence(:email) { |n| "person#{n}@example.com" }
      sequence(:first_name) { |n| "The Tick#{n}" }
      sequence(:last_name) { |n| "Holycowjohnson#{n}" }
      environment "website"
      password "123456"
      password_confirmation "123456"
      social_security_number "141.482.543-93"

      trait :company do
        company_id_number "123456789"
        social_security_number nil
      end

      home_number        "11111111"
      home_area_number   "53"
      mobile_number      "22222222"
      mobile_area_number "54"
      work_number        "33333333"
      work_area_number   "55"

      association :store, factory: :company

      trait :pos do
        environment "point_of_sale"
        password ""
        password_confirmation ""
      end

      # role
      after(:create) do |person, evaluator|
        if evaluator.customer
          role = ::Role.customer.first
          role = role.present? ? role : FactoryGirl.create(:role, :customer)
          person.roles << role
        end
        if evaluator.supplier
          role = ::Role.supplier.first
          role = role.present? ? role : FactoryGirl.create(:role, :supplier)
          person.roles << role
        end
        person.save
      end

      # address
      after(:create) do |person, evaluator|
        if evaluator.create_address
          person.addresses.build(FactoryGirl.attributes_for(:address))
          person.save
        end
      end

      factory :customer, class: "Person" do
      end
    end
  end
end
