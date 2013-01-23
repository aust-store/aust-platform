class CompanySetting < ActiveRecord::Base
  belongs_to :company

  store_accessor :settings, :zipcode

  before_validation :valid_zipcode?

  # defines hstore fields
  ["zipcode"].each do |key|
    attr_accessible key

    define_method(key) { settings && settings[key] }

    define_method("#{key}=") do |value|
      self.settings = (settings || {}).merge(key => value)
    end
  end

  def valid_zipcode?
    if zipcode.present?
      validation = ::Store::Shipping::Correios::ZipcodeValidation.new(zipcode)
      if validation.success?
        true
      else
        errors.add(:zipcode, "CEP invalido")
      end
    end
  end
end