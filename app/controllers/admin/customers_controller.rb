class Admin::CustomersController < Admin::ApplicationController
  def index
    @customers = current_company.customers.order('first_name', 'last_name').page(params[:page])
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
      render :new
    end
  end

  def edit
    @customer = current_company.customers.find(params[:id])
  end

  def update
    @customer = current_company.customers.find(params[:id])

    if @customer.update_attributes(params[:customer])
      redirect_to admin_customer_url(@customer)
    else
      render :edit
    end
  end

  def destroy
    @customer = current_company.customers.find(params[:id])
    @customer.destroy
    redirect_to admin_customers_url, notice: I18n.t('admin.customers.notice.delete')
  end
end
