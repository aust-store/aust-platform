class CompanySetting < ActiveRecord::Base
  belongs_to :company

  store_accessor :settings, :zipcode
  store_accessor :settings, :store_theme

  before_validation :valid_zipcode?, if: ->{ Store::Application.config.auto_validate_company_zipcode }
  after_save :set_default_store_theme, on: :create

  validates :zipcode, numericality: { allow_blank: true },
                      length:       { allow_blank: true, is: 8 }

  def set_default_store_theme
    self.store_theme = "overblue"
  end

  # defines hstore fields
  ["zipcode", "store_theme"].each do |key|
    attr_accessible key

    define_method(key) { settings && settings[key] }

    define_method("#{key}=") do |value|
      self.settings = (settings || {}).merge(key => value)
    end
  end

  def store_theme
    self.settings["store_theme"] || "overblue"
  end

  def valid_zipcode?
    if zipcode.present?
      validation = ::ShippingCalculation::Correios::ZipcodeValidation.new(company_zipcode)
      if validation.invalid_origin_zipcode?
        errors.add(:zipcode, :invalid)
      elsif validation.correios_system_unavailable?
        errors.add(:zipcode, :correios_unavailable)
      elsif validation.unexpected_error?
        errors.add(:zipcode, :unexpected_error)
      else
        true
      end
    end
  end

  private

  def company_zipcode
    ::Store::ZipcodeSanitization.sanitize_zipcode(zipcode)
  end
end
