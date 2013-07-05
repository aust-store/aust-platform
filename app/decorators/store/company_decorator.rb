module Store
  class CompanyDecorator < ApplicationDecorator
    decorates :company
    decorates_association :address, with: AddressDecorator

    def complete_address
      address.complete_address if model.address.present?
    end

    def complete_contact
      phones = []
      if model.contact.present?
        phones << model.contact.phone_1
        phones << model.contact.phone_2
      end
      phones.compact.join(", ")
    end
  end
end
