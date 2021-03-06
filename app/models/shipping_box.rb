class ShippingBox < ActiveRecord::Base
  belongs_to :inventory_items, dependent: :destroy
  belongs_to :order_item, dependent: :destroy

  attr_accessible :height, :inventory_items, :length, :weight, :width, :order_item_id

  before_validation :sanitize_attributes, :calculate_total_dimensions

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
    self.length = Store::DimensionsSanitization.sanitize(length) if length.present?
    self.height = Store::DimensionsSanitization.sanitize(height) if height.present?
    self.width  = Store::DimensionsSanitization.sanitize(width)  if width.present?
    self.weight = Store::DimensionsSanitization.sanitize(weight) if weight.present?
  end

  def calculate_total_dimensions
    if [:width, :height, :length].all? { |f| send(f).present? } == true
      if self.height + self.width + self.length <= 200
        true
      else
        errors.add(:max_box_size)
      end
    end
    true
  end

  private

  # This methods exists so that we can create an errors on the pseudo-field
  # max_box_size, which is the calculation of all dimensions.
  def max_box_size; end
end
