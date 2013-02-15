class InventoryItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :entry_for_sale_id, :on_sale

  include ::ActionView::Helpers::NumberHelper

  def price
    object.price
  end

  def entry_for_sale_id
    object.entry_for_sale.id
  end

  def on_sale
    Store::Policy::ItemOnSale.new(object).on_sale?
  end
end
