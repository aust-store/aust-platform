FactoryGirl.define do
  factory :admin_user_without_associations, class: "AdminUser" do
    sequence(:name) { |s| "The Tick#{s}" }
    sequence(:email) { |s| "user#{s}@example.com" }
    password "1234567"
    password_confirmation "1234567"
    role "founder"

    factory :admin_user do
      association :company
    end
  end
end
