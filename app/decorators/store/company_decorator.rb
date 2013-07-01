module Store
  class CompanyDecorator < ApplicationDecorator
    decorates :company
    decorates_association :address, with: AddressDecorator

    def complete_address
      address.complete_address if model.address.present?
    end
  end
end
