class Address < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :city, :country, :default, :state,
                  :zipcode, :neighborhood

  belongs_to :addressable, polymorphic: true

  validates :address_1, :zipcode, :neighborhood, :city, :state, :country, presence: true
  validates :zipcode, format: { with: /[0-9]{8}|[0-9]{5}\-[0-9]{3}/ }

  before_validation :set_country_to_brazil

  def set_country_to_brazil
    self.country = "BR"
  end
end
