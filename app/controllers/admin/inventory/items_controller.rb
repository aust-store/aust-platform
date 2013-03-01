# encoding: utf-8
class Admin::Inventory::ItemsController < Admin::ApplicationController
  before_filter :load_item, only: [:show, :edit, :destroy]
  before_filter :load_all_taxonomies, only: [:edit, :new, :create, :update]

  def index
    respond_to do |format|
      format.html { @items = current_company.items.last(50) }

      format.js do
        @items = current_company.items.limit(3)
        @items = @items.search_for(params[:search]) if params[:search].present?
        render json: @items, root: 'inventory_items'
      end
    end
  end

  def show
    @item_on_sale      = Store::Policy::ItemOnSale.new(@item).on_sale?

    @item_images       = @item.images.order("cover desc").limit(10).dup

    @inventory_entries = @item.all_entries_available_for_sale
    @inventory_entries = DecorationBuilder.inventory_entries(@inventory_entries)

    @shipping_box      = DecorationBuilder.shipping_box(@item.shipping_box)

    @taxonomy          = @item.taxonomy
    @taxonomy          = @taxonomy.self_and_ancestors.reverse if @taxonomy.present?

    @item              = DecorationBuilder.inventory_items(@item)
  end

  def new
    @item = current_company.items.new

    build_item_associations
  end

  def edit
    @item = current_company.items.includes(:shipping_box).find(params[:id])
    @item.build_shipping_box unless @item.shipping_box.present?

    build_item_associations
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
    params[:inventory_item].delete(:taxonomy_attributes)
    params[:inventory_item].delete(:manufacturer_attributes)
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

  def load_all_taxonomies
    @company_taxonomies = current_company.taxonomies.flat_hash_tree
  end

  def build_item_associations
    @item.entries.build      if @item.entries.blank?
    @item.prices.build       if @item.prices.blank?
    @item.build_taxonomy     if @item.taxonomy.blank?
    @item.build_manufacturer if @item.manufacturer.blank?
    @item.build_shipping_box if @item.shipping_box.blank?
  end
end
