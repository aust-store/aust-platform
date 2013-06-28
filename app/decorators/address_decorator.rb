class AddressDecorator < ApplicationDecorator
  decorates :address

  def complete_address
    complete = []
    complete << model.address_1
    complete << model.address_2
    complete << model.number
    complete << model.neighborhood
    complete << model.city
    complete << model.state
    complete << "CEP #{model.zipcode}" if model.zipcode.present?
    complete.join(", ")
  end
end
