class Admin::CustomersController < Admin::ApplicationController
  def index
    @customers = current_company.customers.all
  end

  def show
    @customer = current_company.customers.find(params[:id])
  end

  def new
    @customer = Customer.new(company: current_company)
  end

  def create
    @customer = Store::CustomerCreation.new(self)

    if @customer.create(params[:customer])
      redirect_to admin_customers_url
    else
      @customer = @customer.ar_instance
      render "new"
    end
  end
end
