# encoding: utf-8
class Pos::Api::InventoryItemsController < Pos::Api::ApplicationController
  def index
    # The mobile admin site (iPhone) requires seeing all the inventory items.
    # The offline sales page requires seeing only inventory items on sale
    # This should return all items
    @resources = current_company.items.order("inventory_items.updated_at desc")
    @resources = @resources.with_point_of_sale

    if params[:on_sale].present?
      @resources = @resources.with_entry_for_sale
    end

    @resources = @resources.search_for(params[:search].strip) if params[:search].present?

    paginate_resource
    render json: @resources, meta: meta
  end
end
