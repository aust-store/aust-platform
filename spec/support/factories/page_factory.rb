FactoryGirl.define do
  factory :page do
    sequence(:title) { |i| "Title ##{i}" }
    body "Texto"
  end
end
