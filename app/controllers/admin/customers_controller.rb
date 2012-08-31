class Admin::CustomersController < Admin::ApplicationController
  def index
    @customers = Customer.within_company(current_company.id).all
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def new
    @customer = Customer.new(company: current_company.id)
  end

  def create
    @customer = Store::CustomerCreation.create(
      params[:customer], current_company.id
    )

    if @customer
      redirect_to admin_customers_url
    else
      render "new"
    end
  end
end
