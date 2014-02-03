class PosCashEntry < ActiveRecord::Base
  include Models::Extensions::UUID
  uuid field: "uuid"

  belongs_to :admin_user
  belongs_to :company

  VALID_TYPES = [:addition, :subtraction, :missing, :surplus]

  validates :entry_type, inclusion: { in: VALID_TYPES + VALID_TYPES.map(&:to_s) }

  before_validation :validate_cash_is_updatable

  scope :newer_order, ->(cash_entry) {
    cash_entry.company.orders.reload
      .created_offline
      .where("orders.created_at >= ?", cash_entry.created_at)
  }

  scope :newer_entry, ->(cash_entry) {
    cash_entry.company.pos_cash_entries
      .reload
      .where("pos_cash_entries.created_at >= ?", cash_entry.created_at)
      .where("pos_cash_entries.id NOT IN (?)",   cash_entry.id)
  }

  private

  def validate_cash_is_updatable
    return true unless self.company.present? # during tests, there's no company
    valid_for_order = self.class.newer_order(self).blank?
    valid_for_entry = self.class.newer_entry(self).blank?
    self.errors.add(:amount, "Pedidos já foram acrescentados") unless valid_for_order
    self.errors.add(:amount, "Outra entrada já foi acrescentados") unless valid_for_entry

    valid_for_order && valid_for_entry
  end
end
