class ShippingBox < ActiveRecord::Base
  belongs_to :inventory_items, dependent: :destroy

  attr_accessible :height, :inventory_items, :length, :weight, :width

  before_validation :sanitize_attributes

  validates :width, :height, :weight, :length,
    presence: true , if: :dependent_fields_present?

  validates :length, numericality: { greater_than_or_equal_to: 18,
                                     less_than_or_equal_to: 105,
                                     allow_blank: true }

  validates :height, numericality: { greater_than_or_equal_to: 2,
                                     less_than_or_equal_to: 105,
                                     allow_blank: true }

  validates :width, numericality: { greater_than_or_equal_to: 11,
                                    less_than_or_equal_to: 105,
                                    allow_blank: true }

  validates :weight, numericality: { greater_than_or_equal_to: 0.3,
                                    less_than_or_equal_to: 30,
                                     allow_blank: true }

  def dependent_fields_present?
    [:width, :height, :weight, :length].any? { |f| send(f).present? }
  end

  def sanitize_attributes
    self.length = Store::NumberSanitizer.sanitize_number(length)
    self.length = BigDecimal.new(length.to_s) if length.present?

    self.height = Store::NumberSanitizer.sanitize_number(height)
    self.height = BigDecimal.new(height.to_s) if height.present?

    self.width  = Store::NumberSanitizer.sanitize_number(width)
    self.width  = BigDecimal.new(width.to_s)  if width.present?

    self.weight = Store::NumberSanitizer.sanitize_number(weight)
    self.weight = BigDecimal.new(weight.to_s) if weight.present?
  end
end