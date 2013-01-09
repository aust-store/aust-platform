class ShippingBox < ActiveRecord::Base
  belongs_to :inventory_items, dependent: :destroy

  attr_accessible :height, :inventory_items, :length, :weight, :width

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
end