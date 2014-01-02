class InventoryItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :entry_for_sale_id, :on_sale

  include ::ActionView::Helpers::NumberHelper

  def id
    object.uuid
  end

  def price
    object.price
  end

  def entry_for_sale_id
    entry_for_sale = object.entry_for_sale
    entry_for_sale.present? ? entry_for_sale.id : nil
  end

  def on_sale
    Store::Policy::ItemOnSale.new(object).on_sale?
  end
end
