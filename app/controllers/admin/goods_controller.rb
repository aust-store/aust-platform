# encoding: utf-8
class Admin::GoodsController < Admin::ApplicationController
  before_filter :load_good, only: [:show, :edit, :destroy]

  def index
    @goods = Good.within_company(current_user.company).all
  end

  def new_good_or_balance; end

  def search
    @goods = Good.search_for(params[:name],
                             current_user.company_id,
                             page: 1, per_page: 10)
    render "search", layout: false
  end

  def show
    @good = Good.find(params[:id])
  end

  def new
    @good = Good.new
  end

  def edit
    @good = Good.find params[:id]
  end

  def create
    # TODO Good::Creation would make sense here to remove this logic from
    # the controller
    @good = Good.new params[:good]
    @good.user = current_user
    @good.company = current_user.company
    if @good.save
      redirect_to admin_inventory_goods_url
    else
      render "new"
    end
  end

  def update
    # TODO remove this logic from the controller
    @good = Good.find params[:id]
    if @good.update_attributes params[:good]
      if remotipart_submitted?
        return render partial: "shared/images", layout: false
      end
      redirect_to admin_inventory_good_url(@good)
    else
      render "edit"
    end
  end

  def destroy
    @good = Good.find params[:id]
    if @good.destroy
      redirect_to admin_inventory_goods_url
    else
      redirect_to admin_inventory_goods_url, failure: "error message"
    end
  end

  private

  def load_good
    @good = Good.find params[:id]
  end

  def has_images good
    return true unless good.images.blank?
    return false if good.images.first.blank?
    return false if good.images.first.id
    true
  end
end
