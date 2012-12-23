FactoryGirl.define do
  factory :address do
    address_1  "221B, Baker street"
    address_2  "Obviously not 221A"
    neighborhood  "Center"
    zipcode "96360000"
    city "London"
    state "RS"
    country "BR"

    factory :american_address do
      country "US"
    end
  end
end
