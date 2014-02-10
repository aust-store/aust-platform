FactoryGirl.define do
  factory :cash_entry, class: "PosCashEntry" do
    sequence(:amount) { |i| "#{i}0.0" }
    entry_type "addition"
    description "Cash entry amount"
  end
end
