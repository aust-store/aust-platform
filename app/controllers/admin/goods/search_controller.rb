class Admin::Goods::SearchController < Admin::ApplicationController
  before_filter :search_goods

  layout false

  def for_adding_balance
    @path = Proc.new { |resource| new_admin_inventory_good_balance_path(resource) }
    render_results
  end

  def index
    @path = Proc.new { |resource| admin_inventory_good_path(resource) }
    render_results
  end

  private

  def render_results
    render "default_results"
  end

  def search_goods
   @resources = Good.search_for params[:name], current_user.company_id, page: 1, per_page: 10
  end
end
