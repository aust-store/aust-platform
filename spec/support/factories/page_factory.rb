FactoryGirl.define do
  factory :page do
    sequence(:title) { |i| "Title ##{i}" }
  end
end
