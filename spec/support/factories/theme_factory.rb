FactoryGirl.define do
  factory :theme do
    name "Overblue"
    public true
    path "overblue"
    initialize_with { Theme.where(path: path).first_or_create }

    trait :overblue do
      name "Overblue"
      path "over_blue"
    end

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

    # minimalism has vertical taxonomy menu
    trait :minimalism do
      name "Minimalism"
      public true
      path "minimalism"
      vertical_taxonomy_menu true
    end
  end
end
