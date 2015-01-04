#
# This is specific to the Point of sale and shouldn't be used for the website
class InventoryEntrySerializer < ActiveModel::Serializer
  attributes :id, :quantity
end
