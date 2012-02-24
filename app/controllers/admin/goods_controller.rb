class Admin::GoodsController < Admin::ApplicationController
  inherit_resources

  def create
    create! { redirect_to admin_inventory_goods_url and return }
  end
end
