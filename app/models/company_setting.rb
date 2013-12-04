class CompanySetting < ActiveRecord::Base
  belongs_to :company

  store_accessor :settings, :zipcode, :google_analytics_id

  before_validation :valid_zipcode?, if: ->{ Store::Application.config.auto_validate_company_zipcode }
  validates :zipcode, numericality: { allow_blank: true },
                      length:       { allow_blank: true, is: 8 }

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
