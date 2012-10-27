# encoding: utf-8
class Admin::Financial::AccountReceivablesController < Admin::ApplicationController
  def index
    @receivables = decorate(AccountReceivable.all)
  end

  def new
    @receivable = decorate(AccountReceivable.new(customer_id: params[:customer_id])) 
  end

  def edit
    @receivable = decorate(AccountReceivable.find(params[:id]))
  end

  def create
    # TODO change this failed DCI attempt. Maybe use
    # Receivables::Creation
    @context = ReceivablesManagementContext.new(params, current_user)
    if @context.save_receivable
      redirect_to admin_customer_account_receivables_url, notice: "Conta a receber cadastrada."
    else
      @receivable = decorate(@context.resource)
      render :new
    end
  end

  def update
    @context = ReceivablesManagementContext.new(params)
    if @context.update_receivable
      redirect_to admin_customer_account_receivables_url, notice: "Conta a receber salva."
    else
      @receivable = decorate(@context.resource)
      render :edit
    end
  end

  def destroy
    @context = ReceivablesManagementContext.new(params).delete_receivable
    redirect_to admin_customer_account_receivables_url, notice: "Conta a receber salva."
  end

  private

  def decorate(resource)
    Admin::AccountReceivableDecorator.decorate(resource)
  end
end
