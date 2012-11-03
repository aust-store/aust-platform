class GoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price

  include ::ActionView::Helpers::NumberHelper
  
  def price
    to_currency(object.price) || ""
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
