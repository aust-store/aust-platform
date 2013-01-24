class AddressDecorator < ApplicationDecorator
  decorates :address

  def complete_address
    complete = []
    complete << address.address_1
    complete << address.address_2
    complete << address.number
    complete << address.neighborhood
    complete << address.city
    complete << address.state
    complete << "CEP #{address.zipcode}" if address.zipcode.present?
    complete.join(", ")
  end
end
