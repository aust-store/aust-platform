unless Rails.env.production?
  require 'ostruct'
  require 'rubygems'
  require 'bundler/setup'

  require 'rake'
  require 'rspec/core/rake_task'

  namespace :payment_simulation do

    def fake_notification(status)
      fake_notification = OpenStruct.new
      fake_notification.id = ENV['order_id']
      fake_notification.status = status
      fake_notification.unique_id_within_gateway = "123456789"
      fake_notification
    end

    def valid_arguments
      unless ENV['order_id'].present?
        puts "No order_id value was defined."
        return false
      end
      Order.find(ENV['order_id'])
      true
    end

    def description(status)
      "Simulates the response from the payment gateway, marking an order as #{status}; use order_id=:id to specify the order id."
    end

    [ :approved, :in_analysis, :processing, :available_for_withdrawal,
      :disputed, :refunded, :cancelled ].each do |status|

      desc description(status)
      task status do |t|
        return valid_arguments unless valid_arguments
        Store::Order::StatusChange.change(fake_notification(status))
      end
    end
  end
end
