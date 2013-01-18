FactoryGirl.define do
  factory :taxonomy do
    sequence(:name) { |i| "Category ##{i}" }

    after(:create) do |taxonomy, evaluator|
      Taxonomy.create(name: "#{taxonomy.name} son", parent: taxonomy)
    end
  end
end
