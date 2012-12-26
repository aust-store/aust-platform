class PaymentStatus < ActiveRecord::Base
  belongs_to :order
  attr_accessible :notification_id, :order_id, :status

  validates :order_id, presence: true

  VALID_STATUSES = [
    :approved, :in_analysis, :processing, :available_for_withdrawal,
    :disputed, :refunded, :cancelled
  ]

  def set_status_as(status_string)
    return unless VALID_STATUSES.include?(status_string.to_sym)
    self.status = status_string
    save
  end
end
