class CustomField < ActiveRecord::Base
  VALID_FIELD_TYPES = [:string, :radio]

  belongs_to :company
  has_and_belongs_to_many :taxonomies

  before_save :create_alphanumeric_name

  validates :name, uniqueness: true
  validates :name, presence: true
  validates :related_type, presence: true
  validates :field_type, presence: true,
    inclusion: { in: VALID_FIELD_TYPES + VALID_FIELD_TYPES.map(&:to_s) }

  scope :for_inventory_items, ->{ where(related_type: "InventoryItem") }

  def string?
    self.field_type == "string"
  end

  def radio?
    self.field_type == "radio"
  end

  def radio_values(compact = true)
    return [] unless options.present?
    values = options["values"]
    values = ActiveSupport::JSON.decode(values) unless values.respond_to?(:each)
    return values.delete_if { |v| v.blank? } if compact
    values
  end

  private

  def create_alphanumeric_name
    return if self.alphanumeric_name.present?
    self.alphanumeric_name = self.name
      .parameterize
      .gsub(/\s/, "_")
      .gsub(/-/, "_")
      .gsub(/[^_0-9a-zA-Z]/, "")
      .downcase

    increment = 2
    original_name = self.alphanumeric_name
    while duplicated_alphanumeric_name?
      self.alphanumeric_name = "#{original_name}_#{increment}"
      increment += 1
    end
  end

  def duplicated_alphanumeric_name?(name = self.alphanumeric_name)
    CustomField.where(company_id: self.company_id,
                      alphanumeric_name: name).count > 0
  end
end
