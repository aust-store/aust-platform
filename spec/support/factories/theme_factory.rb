FactoryGirl.define do
  factory :theme do
    name "Overblue"
    public true
    path "overblue"
    initialize_with { Theme.find_or_create_by_path(path) }

    trait :flat_pink do
      name "Flat Pink"
      path "flat_pink"
    end
  end
end
