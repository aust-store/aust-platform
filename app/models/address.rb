class Address < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :number, :city, :country, :default, :state,
                  :zipcode, :neighborhood

  belongs_to :addressable, polymorphic: true

  validates :address_1, :zipcode, :neighborhood, :number, :city, :state, :country, presence: true
  validates :zipcode, format: { with: /[0-9]{8}|[0-9]{5}\-[0-9]{3}/ }

  before_validation :set_country_to_brazil

  def set_country_to_brazil
    self.country = "BR"
  end

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
end
