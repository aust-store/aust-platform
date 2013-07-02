FactoryGirl.define do
  factory :theme do
    name "Overblue"
    public true
    path "overblue"
    initialize_with { Theme.where(path: path).first_or_create }

    trait :flat_pink do
      name "Flat Pink"
      path "flat_pink"
    end

    trait :private do
      name "PrivateBlue"
      public false
      path "private_blue"
      company_id 9999
    end
  end
end
