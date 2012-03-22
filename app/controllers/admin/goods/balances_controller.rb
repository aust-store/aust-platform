class Admin::Goods::BalancesController < Admin::ApplicationController
  before_filter :load_good
  before_filter :sanitize_params, only: [:create, :update]

  def index
    @balances = @good.balances
  end

  def new
    @balance = @good.balances.build
  end

  def create
    @balance = @good.balances.build params[:good_balance]
    @balance.balance_type = "in"
    if @balance.save
      redirect_to admin_inventory_good_balances_url(@balance.good)
    else
      render "new"
    end
  end

  def update
    @balance = @good.balances.find params[:id]
    if @balance.update_attributes params[:good_balance]
      redirect_to admin_inventory_good_balances_url(@balance.good)
    else
      render "edit"
    end
  end

  private

  def load_good
    @good = Good.where(id: params[:good_id]).within_company(current_user.company).first
    raise "This doesn't belong to you" if @good.nil?
  end

  def sanitize_params
    good_params = params[:good_balance]
    params[:good_balance][:cost_per_unit] = Store::Currency.to_float good_params[:cost_per_unit]
  end
end
