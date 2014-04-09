# encoding: utf-8
class Admin::Inventory::ItemsController < Admin::ApplicationController
  before_filter :load_item,          only: [:show, :edit, :destroy]
  before_filter :load_taxonomies,    only: [:edit, :new, :create, :update]
  before_filter :load_custom_fields, only: [:edit, :new, :create, :update]

  def index
    items = company_resources
      .includes(:manufacturer)
      .order("inventory_items.updated_at DESC")
      .page(params[:page])

    if params[:search].present? && params[:search][:query].present?
      @search_query = params[:search][:query]
      items = items.search_for(params[:search][:query])
    end

    @items = DecorationBuilder.inventory_items(items)
    last_addition  = company_resources.last
    @last_addition = DecorationBuilder.inventory_items(last_addition)
  end

  def show
    @deletable = Store::InventoryItem::Deletable.new(@item).valid?

    @item_on_sale = Store::Policy::ItemOnSale.new(@item).on_sale?
    @reasons_why_not_on_sale = Store::OnlineSales::ReasonForItemNotOnSale.new(@item).reasons

    @item_images       = @item.images.default_order.limit(10).dup

    @inventory_entries = @item.all_entries_elligible_for_sale
    @inventory_entries = DecorationBuilder.inventory_entries(@inventory_entries)

    @shipping_box      = DecorationBuilder.shipping_box(@item.shipping_box)

    @taxonomy          = @item.taxonomy
    @taxonomy          = @taxonomy.self_and_ancestors.reverse if @taxonomy.present?

    @item              = DecorationBuilder.inventory_items(@item)
  end

  def new
    load_suppliers
    item = current_company.items.new

    @item = View::Form::InventoryItem.new(self).form_object(item)
  end

  def edit
    load_suppliers
    @show_entry_fields = false
    item = current_company.items.includes(:shipping_box).friendly.find(params[:id])

    @item = View::Form::InventoryItem.new(self).form_object(item)
  end

  def create
    cleanup_params_before_saving

    @item = current_company.items.new(params[:inventory_item].merge(user: current_user))
    build_item_associations
    build_nested_fields_errors

    if @item.save(params[:inventory_item])
      redirect_to admin_inventory_items_url,
        notice: I18n.t("admin.default_messages.create.success")
    else
      load_suppliers
      build_nested_fields_errors
      @item = View::Form::InventoryItem.new(self).form_object(@item)
      render "new"
    end
  end

  def update
    cleanup_params_before_saving

    @item = current_company.items.friendly.find params[:id]
    build_item_associations

    if @item.update_attributes params[:inventory_item]
      redirect_to admin_inventory_item_url(@item),
        notice: I18n.t("admin.default_messages.update.success")
    else
      load_suppliers
      build_item_associations
      build_nested_fields_errors
      @item = View::Form::InventoryItem.new(self).form_object(@item)
      render "edit"
    end
  end

  def destroy
    @item = current_company.items.friendly.find(params[:id])
    if @item.destroy
      redirect_to admin_inventory_items_url, notice: "Item excluído com sucesso"
    else
      redirect_to admin_inventory_items_url, failure: "error message"
    end
  end

  private

  def load_item
    @item = current_company.items.friendly.find params[:id]
  end

  def has_images item
    return false if item.images.blank?
    return false if item.images.first.blank?
    true
  end

  def load_taxonomies
    @company_taxonomies = current_company.taxonomies.flat_hash_tree
  end

  def build_item_associations
    @item.prices.build       if @item.prices.blank?
    @item.build_taxonomy     if @item.taxonomy.blank?
    @item.build_shipping_box if @item.shipping_box.blank?
  end

  def cleanup_params_before_saving
    # deletes params that are invalid e shouldn't be used to generate a
    # resource
    params[:inventory_item].delete(:taxonomy_attributes)

    # If an ID was passed in from the form
    if params[:inventory_item][:manufacturer_id].present?
      params[:inventory_item].delete(:manufacturer_attributes)

    # If no ID, but a name
    elsif params[:inventory_item][:manufacturer_attributes].present? &&
          params[:inventory_item][:manufacturer_attributes][:name].present?

      name = params[:inventory_item][:manufacturer_attributes][:name]
      manufacturer = current_company.manufacturers.where(name: name).first

      if manufacturer.present?
        params[:inventory_item][:manufacturer_id] = manufacturer.id
        params[:inventory_item].delete(:manufacturer_attributes)
      end
    else
      params[:inventory_item].delete(:manufacturer_attributes)
    end

    #
    # Defines admin_user and store for entries
    if params[:inventory_item][:entries_attributes].present?
      params[:inventory_item][:entries_attributes].each do |key, value|
        params[:inventory_item][:entries_attributes][key][:admin_user_id] = current_user.id
        params[:inventory_item][:entries_attributes][key][:store_id] = current_company.id
      end
    end

    #
    # Defines admin_user and store for manufacturer
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

  def company_resources
    current_company.items
  end

  def load_custom_fields
    @custom_fields = current_company.custom_fields.where(related_type: "InventoryItem")
  end

  def load_suppliers
    @suppliers = current_company.suppliers.to_a.map { |s| [s.first_name, s.id] }
  end
end
