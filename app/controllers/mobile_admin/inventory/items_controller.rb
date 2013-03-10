# encoding: utf-8
class MobileAdmin::Inventory::ItemsController < MobileAdmin::ApplicationController
  before_filter :load_item,           only: [:show, :edit, :destroy]
  before_filter :load_all_taxonomies, only: [:edit, :new, :create, :update]

  def index
    respond_to do |format|
      format.html do
        items  = current_company.items.order('id desc').limit(6)
        @items = DecorationBuilder.inventory_items(items)
      end

      format.js do
        @items = current_company.items.limit(3)
        @items = @items.search_for(params[:search]) if params[:search].present?
        render json: @items, root: 'inventory_items'
      end
    end
  end

  def show
    @item_on_sale      = Store::Policy::ItemOnSale.new(@item).on_sale?

    @item_images       = @item.images.default_order.dup

    @inventory_entries = @item.all_entries_available_for_sale
    @inventory_entries = DecorationBuilder.inventory_entries(@inventory_entries)

    @shipping_box      = DecorationBuilder.shipping_box(@item.shipping_box)

    @taxonomy          = @item.taxonomy
    @taxonomy          = @taxonomy.self_and_ancestors.reverse if @taxonomy.present?

    @item              = DecorationBuilder.inventory_items(@item)
  end

  private

  def load_item
    @item = current_company.items.find params[:id]
  end
end
