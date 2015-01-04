#
# This is specific to the Point of sale and shouldn't be used for the website
class InventoryItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description,
    :price, :price_for_installments,
    :entry_for_sale_id, :on_sale,
    :barcode, :reference_number

  include ::ActionView::Helpers::NumberHelper

  def id
    object.uuid
  end

  def price
    object.price
  end

  def entry_for_sale_id
    entry_for_sale = object.entry_for_point_of_sale
    entry_for_sale.present? ? entry_for_sale.id : nil
  end

  def on_sale
    Store::Policy::ItemOnSale.new(object).on_sale?
  end
end
