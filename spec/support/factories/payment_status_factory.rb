FactoryGirl.define do
  factory :payment_status do
    notification_id "123456789"
    order_id 1

    factory(:payment_approved)   { status :approved }
    factory(:payment_available_for_withdrawal) { status :available_for_withdrawal }
    factory(:payment_processing) { status :processing }
    factory(:payment_refunded)   { status :refunded }
  end
end
