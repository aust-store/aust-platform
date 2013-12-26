# encoding: utf-8
class Admin::Api::InventoryItemsController < Admin::ApplicationController
  def index
    # The mobile admin site (iPhone) requires seeing all the inventory items.
    # The offline sales page requires seeing only inventory items on sale
    # This should return all items
    @items = current_company.items.order("inventory_items.id desc")

    if params[:on_sale].present?
      @items = @items.items_on_sale
    end

    @items = @items.limit(4)
    @items = @items.search_for(params[:search].strip) if params[:search].present?

    render json: @items
  end
end
