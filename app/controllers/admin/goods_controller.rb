# encoding: utf-8 
class Admin::GoodsController < Admin::ApplicationController
  before_filter :load_good, only: [:show, :edit, :update, :destroy]

  def index
    @goods = Good.within_company(current_user.company).all
  end

  def new_good_or_balance; end

  def search
    @goods = Good.search_for params[:name], current_user.company_id, page: 1, per_page: 10
    render "search", layout: false
  end

  def show
  end

  def new
    @good = Good.new
  end
  
  def edit
  end

  def create
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
    if @good.update_attributes params[:good]
      redirect_to admin_inventory_goods_url
    else
      render "edit"
    end
  end

  def destroy
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
end
