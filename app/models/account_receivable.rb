class AccountReceivable < ActiveRecord::Base
  belongs_to :customer
  belongs_to :company
  belongs_to :admin_user

  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :admin_user, presence: true
end
