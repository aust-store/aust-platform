class Admin::CustomersController < Admin::ApplicationController
  before_filter :fetch_customer, only: [:show, :edit, :update, :destroy]

  def index
    @customers = current_company
     .customers
     .order('first_name', 'last_name')
     .page(params[:page])
     .per(25)
  end

  def show
    @customer = CustomerDecorator.decorate(@customer)
  end

  def edit
    @customer.addresses.build unless @customer.addresses.present?
  end

  def update
    customer_params = params[:customer]

    if customer_params[:password].blank?
      customer_params.delete("password")
      customer_params.delete("password_confirmation")
    end

    if @customer.update_attributes(customer_params)
      redirect_to admin_customer_url(@customer)
    else
      render :edit
    end
  end

  def destroy
    @customer.disable
    redirect_to admin_customers_url, notice: I18n.t('admin.customers.notice.delete')
  end

  private

  def fetch_customer
    @customer = current_company.customers.find(params[:id])
  end
end
