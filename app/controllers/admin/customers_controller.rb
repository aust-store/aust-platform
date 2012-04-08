class Admin::CustomersController < Admin::ApplicationController

  def index
     @customers = Customer.within_company(current_user.company).all
  end

  def new
    @customer = Customer.new(company: current_user.company)
  end

  def create
    @customer = Customer.new params[:customer]
    @customer.company = current_user.company

    if @customer.save
      redirect_to admin_customers_url
    else
      render "new"
    end
  end
end
