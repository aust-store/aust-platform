# encoding: utf-8
class Admin::Api::InventoryItemsController < Admin::ApplicationController
  def index
    @items = current_company.items.limit(4)
    @items = @items.search_for(params[:search].strip) if params[:search].present?

    render json: @items, root: 'inventory_items'
  end
end
