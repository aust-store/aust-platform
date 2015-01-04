class Address < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :number, :city, :country, :default,
                  :state, :zipcode, :neighborhood, :addressable

  belongs_to :addressable, polymorphic: true

  validates :address_1, :zipcode, :neighborhood, :number, :city,
    :state, :country, presence: true, if: :validate?
  validates :zipcode, format: { with: /[0-9]{8}|[0-9]{5}\-[0-9]{3}/ }, allow_blank: true
  validates :state, inclusion: { in: Geography::BrazilianStates.states_codes }, allow_blank: true

  before_validation :set_country_to_brazil
  before_save :set_default_address

  def copied
    attributes.reject do |key, value|
      [ 'id',
        'addressable_id',
        'addressable_type',
        'updated_at',
        'created_at',
        'default'
      ].include?(key)
    end
  end

  def do_not_validate
    @validate = false
  end

  def validate?
    @validate.nil? ? true : @validate
  end

  private

  def set_country_to_brazil
    self.country = "BR"
  end

  def set_default_address
    if same_level_addresses.size == 0
      self.default = true
    elsif same_level_addresses.size >= 1 && self.default?
      not_default = same_level_addresses.to_a.delete_if { |a| a == self }
      not_default.each { |a| a.update_attribute(:default, false) }
    end
  end

  def same_level_addresses
    @same_level_addresses ||= Address
      .where("addressable_id = ? AND addressable_type = ?",
             self.addressable_id, self.addressable_type)
  end
end
