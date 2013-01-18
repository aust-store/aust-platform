class InventoryItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :on_sale

  include ::ActionView::Helpers::NumberHelper

  def price
    to_currency(object.price) || ""
  end

  def on_sale
    Store::Policy::ItemOnSale.new(object).on_sale?
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
