class CustomField < ActiveRecord::Base
  belongs_to :company
  has_and_belongs_to_many :taxonomies

  before_save :create_alphanumeric_name

  validates :name, uniqueness: true
  validates :name, presence: true
  validates :related_type, presence: true

  scope :for_inventory_items, ->{ where(related_type: "InventoryItem") }

  private

  def create_alphanumeric_name
    return if self.alphanumeric_name.present?
    self.alphanumeric_name = self.name
      .gsub(/\s/, "_")
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
