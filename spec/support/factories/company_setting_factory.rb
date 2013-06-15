FactoryGirl.define do
  factory :company_setting do
    after(:create) do |settings, evaluator|
      settings.zipcode = 96360000
      settings.store_theme = "overblue"
      settings.save
    end
  end
end
