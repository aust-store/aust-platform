FactoryGirl.define do
  factory :banner do
    sequence(:title) { |i| "My good banner ##{i}"}
    position "all_pages_right"
    url "http://www.google.com"
    image File.open("#{Rails.root.to_s}/spec/support/fixtures/image.png")
  end
end
