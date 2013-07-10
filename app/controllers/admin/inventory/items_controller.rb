# encoding: utf-8
class Admin::Inventory::ItemsController < Admin::ApplicationController
  before_filter :load_item,           only: [:show, :edit, :destroy]
  before_filter :load_all_taxonomies, only: [:edit, :new, :create, :update]

  def index
    items  = current_company.items.order("updated_at desc").last(50)
    @items = DecorationBuilder.inventory_items(items)
  end

  def show
    @item_on_sale      = Store::Policy::ItemOnSale.new(@item).on_sale?
    @reasons_why_not_on_sale = Store::OnlineSales::ReasonForItemNotOnSale.new(@item).reasons

    @item_images       = @item.images.default_order.limit(10).dup

    @inventory_entries = @item.all_entries_available_for_sale
    @inventory_entries = DecorationBuilder.inventory_entries(@inventory_entries)

    @shipping_box      = DecorationBuilder.shipping_box(@item.shipping_box)

    @taxonomy          = @item.taxonomy
    @taxonomy          = @taxonomy.self_and_ancestors.reverse if @taxonomy.present?

    @item              = DecorationBuilder.inventory_items(@item)
  end

  def new
    @item = current_company.items.new
    @item.entries.build if @item.entries.blank?

    build_item_associations
    @item.build_manufacturer if @item.manufacturer.blank?
  end

  def edit
    @show_entry_fields = false
    @item = current_company.items.includes(:shipping_box).find(params[:id])

    build_item_associations
    @item.build_manufacturer if @item.manufacturer.blank?
    @item = DecorationBuilder.inventory_items(@item)
  end

  def create
    delete_params_before_saving
    set_company_and_admin_to_new_manufacturer
    set_store_and_admin_user_to_entries

    @item = current_company.items.new(params[:inventory_item].merge(user: current_user))
    build_item_associations
    build_nested_fields_errors

    if @item.save(params[:inventory_item])
      redirect_to admin_inventory_items_url
    else
      build_nested_fields_errors
      @item.build_manufacturer if @item.manufacturer.blank?
      @item = DecorationBuilder.inventory_items(@item)
      render "new"
    end
  end

  def update
    delete_params_before_saving
    set_company_and_admin_to_new_manufacturer
    set_store_and_admin_user_to_entries

    @item = current_company.items.find params[:id]
    build_item_associations

    if @item.update_attributes params[:inventory_item]
      redirect_to admin_inventory_item_url(@item)
    else
      build_item_associations
      @item.build_manufacturer if @item.manufacturer.blank?
      build_nested_fields_errors
      @item = DecorationBuilder.inventory_items(@item)
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
    @item.prices.build       if @item.prices.blank?
    @item.build_taxonomy     if @item.taxonomy.blank?
    @item.build_shipping_box if @item.shipping_box.blank?
  end

  def set_store_and_admin_user_to_entries
    if params[:inventory_item][:entries_attributes].present?
      params[:inventory_item][:entries_attributes].each do |key, value|
        params[:inventory_item][:entries_attributes][key][:admin_user_id] = current_user.id
        params[:inventory_item][:entries_attributes][key][:store_id] = current_company.id
      end
    end
  end

  def set_company_and_admin_to_new_manufacturer
    if params[:inventory_item][:manufacturer_attributes].present?
      if params[:inventory_item][:manufacturer_attributes][:name].present?
        params[:inventory_item][:manufacturer_attributes][:company_id] = current_company.id
        params[:inventory_item][:manufacturer_attributes][:admin_user_id] = current_user.id
      end
    end
  end

  def build_nested_fields_errors
    @item.taxonomy.errors.add(:name, :blank) if @item.taxonomy_id.blank?

    @item.valid?
    @item.errors.messages.delete(:taxonomy_id)
    @item.errors.messages.delete(:manufacturer_id)
  end

  def delete_params_before_saving
    params[:inventory_item].delete(:taxonomy_attributes)

    if params[:inventory_item][:manufacturer_attributes].present? && params[:inventory_item][:manufacturer_attributes][:name].present?
      params[:inventory_item].delete(:manufacturer_id)
    elsif params[:inventory_item][:manufacturer_id].present?
      params[:inventory_item].delete(:manufacturer_attributes)
    else
      params[:inventory_item].delete(:manufacturer_attributes)
      params[:inventory_item].delete(:manufacturer_id)
    end
  end
end
