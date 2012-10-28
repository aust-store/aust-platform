# encoding: utf-8
class Admin::GoodsController < Admin::ApplicationController
  before_filter :load_good, only: [:show, :edit, :destroy]

  def index
    @goods = current_company.items.all
  end

  def new_good_or_entry; end

  def show
    good = current_company.items.find(params[:id])
    @item_images = good.images.order("cover desc").limit(11).dup
    @good = ::DecorationBuilder.good(good)
  end

  def new
    @good = current_company.items.new(name: params[:new_item_name])
  end

  def edit
    @good = current_company.items.find params[:id]
  end

  def create
    @good = Store::InventoryItemCreation.new(self)
    if @good.create(params[:good])
      redirect_to admin_inventory_goods_url
    else
      @good = @good.active_record_item
      render "new"
    end
  end

  def update
    # TODO remove this logic from the controller
    @good = current_company.items.find params[:id]
    if @good.update_attributes params[:good]
      if remotipart_submitted?
        @good_images = @good.images.dup
        return render partial: "shared/images", layout: false
      end
      redirect_to admin_inventory_good_url(@good)
    else
      render "edit"
    end
  end

  def destroy
    @good = current_company.items.find params[:id]
    if @good.destroy
      redirect_to admin_inventory_goods_url
    else
      redirect_to admin_inventory_goods_url, failure: "error message"
    end
  end

  private

  def load_good
    @good = current_company.items.find params[:id]
  end

  def has_images good
    return false if good.images.blank?
    return false if good.images.first.blank?
    true
  end
end
