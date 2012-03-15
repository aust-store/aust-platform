class Admin::Goods::BalancesController < Admin::ApplicationController
  inherit_resources

  defaults resource_class: Good::Balance, collection_name: 'balances', instance_name: 'balance'

  belongs_to :good

  def index
    @good = Good.find(params[:good_id])
  end

  def create
    build_resource.balance_type = "in"
    create! do |format|
      if resource.valid?
        format.html { redirect_to admin_inventory_good_balances_url(resource.good) }
      else
        format.html { render "new" }
      end
    end
  end
end
