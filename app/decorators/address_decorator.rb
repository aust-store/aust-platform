class AddressDecorator < ApplicationDecorator
  decorates :address

  def complete_address
    complete = []
    complete << "#{model.address_1}, #{model.number}"
    complete << model.address_2 if model.address_2.present?
    complete << model.neighborhood
    complete << model.city
    complete << model.state
    complete << "CEP #{model.zipcode}" if model.zipcode.present?
    complete.join(", ")
  end

  def address_1
    "#{model.address_1}, #{model.number}"
  end
end
