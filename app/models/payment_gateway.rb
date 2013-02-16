class PaymentGateway < ActiveRecord::Base
  belongs_to :store, foreign_key: :store_id, class_name: "Company"

  attr_accessible :email, :name, :store_id, :token

  before_validation :sanitize_token

  def sanitize_token
    self.token = self.token.strip if self.token.present?
    true
  end

  def active?
    email.present? && name.present? && token.present?
  end
end
