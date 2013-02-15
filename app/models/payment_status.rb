class PaymentStatus < ActiveRecord::Base
  belongs_to :order
  attr_accessible :notification_id, :order_id, :status

  validates :order_id, presence: true

  VALID_STATUSES = [
    :approved, :in_analysis, :processing, :available_for_withdrawal,
    :disputed, :refunded, :cancelled
  ]

  scope :paid_status, ->{ where(status: "approved") }

  def set_status_as(status_string)
    return unless VALID_STATUSES.include?(status_string.to_sym)
    self.status = status_string
    save
  end

  def self.current_status
    last_status = self.last and last_status = last_status.status.to_sym
    last_status || :undefined
  end

  def self.paid?
    [:approved, :available_for_withdrawal].include? current_status
  end

  def self.cancelled?
    [:cancelled, :refunded, :disputed].include? current_status
  end
end
