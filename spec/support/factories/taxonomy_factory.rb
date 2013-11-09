FactoryGirl.define do
  factory :single_taxonomy, class: "Taxonomy" do
    sequence(:name) { |i| "Category ##{i}" }

    factory :taxonomy do
      after(:create) do |taxonomy, evaluator|
        Taxonomy.create(name: "#{taxonomy.name} son", parent: taxonomy)
      end
    end
  end
end
