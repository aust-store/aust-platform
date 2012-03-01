# encoding: utf-8 
class Admin::GoodsController < Admin::ApplicationController
  inherit_resources

  def new_good_or_balance
  end

  def search
    @goods = Good.search {
      fulltext params[:name]
      paginate page: 1, per_page: 10
    }.results
    render "search", layout: false
  end

  def create
    create! do |format|
      if resource.valid?
        format.html { redirect_to admin_inventory_goods_url }
      else
        format.html { render "new" }
      end
    end
  end

  def update
    update! do |format|
      unless resource.valid?
        format.html { render "edit" and return }
      else
        format.html { redirect_to admin_inventory_goods_url and return }
      end
    end
  end

  def destroy
    destroy! {
      redirect_to admin_inventory_goods_url and return
    }
  end
end
