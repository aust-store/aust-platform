class PaymentGateway < ActiveRecord::Base
  belongs_to :store, foreign_key: :store_id, class_name: "Company"

  attr_accessible :email, :name, :store_id, :token

  def active?
    email.present? && name.present? && token.present?
  end
end
