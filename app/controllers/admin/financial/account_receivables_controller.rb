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
    @context = ReceivablesManagementContext.new(params, current_user)
    if @context.save_receivable
      redirect_to admin_customer_account_receivables_path, notice: "Conta a receber cadastrada."
    else
      @receivable = decorate(@context.resource)
      render :new
    end
  end

  private

  def decorate(resource)
    Admin::AccountReceivableDecorator.decorate(resource)
  end
end
