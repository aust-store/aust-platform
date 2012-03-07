# encoding: utf-8 
class Admin::GoodsController < Admin::ApplicationController
  inherit_resources

  def index
    @goods = Good.within_company(current_user.company).all
  end

  def new_good_or_balance
  end

  def search
    @goods = Good.search {
      fulltext params[:name]
      paginate page: 1, per_page: 10
      with :company_id, current_user.company_id
    }.results
    render "search", layout: false
  end

  def create
    build_resource.user = current_user
    resource.company = current_user.company
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
