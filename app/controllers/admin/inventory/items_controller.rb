# encoding: utf-8
class Admin::Inventory::ItemsController < Admin::ApplicationController
  before_filter :load_item, only: [:show, :edit, :destroy]

  def index
    @items = current_company.items.all
  end

  def new_item_or_entry; end

  def show
    item = current_company.items.find(params[:id])
    @item_images = item.images.order("cover desc").limit(10).dup
    @item = DecorationBuilder.inventory_items(item)
    balances = item.all_entries_available_for_sale
    @inventory_entries = DecorationBuilder.inventory_entries(balances)
  end

  def new
    @item = current_company.items.new(name: params[:new_item_name])
    @item.build_shipping_box
  end

  def edit
    @item = current_company.items.includes(:shipping_box).find(params[:id])
    @item = DecorationBuilder.inventory_items(@item)
  end

  def create
    @item = Store::InventoryItemCreation.new(self)
    if @item.create(params[:inventory_item])
      redirect_to admin_inventory_items_url
    else
      @item = @item.active_record_item
      render "new"
    end
  end

  def update
    @item = current_company.items.find params[:id]
    if @item.update_attributes params[:inventory_item]
      if remotipart_submitted?
        @item_images = @item.images.dup
        return render partial: "shared/images", layout: false
      end
      redirect_to admin_inventory_item_url(@item)
    else
      render "edit"
    end
  end

  def destroy
    @item = current_company.items.find params[:id]
    if @item.destroy
      redirect_to admin_inventory_items_url
    else
      redirect_to admin_inventory_items_url, failure: "error message"
    end
  end

  private

  def load_item
    @item = current_company.items.find params[:id]
  end

  def has_images item
    return false if item.images.blank?
    return false if item.images.first.blank?
    true
  end
end
