# encoding: utf-8
class Admin::Financial::ReceivablesController < Admin::ApplicationController
  def index
    @receivables = Admin::ReceivablePresenter.map(AccountReceivable.all)
  end

  def new
    @receivable = Admin::ReceivablePresenter.new(AccountReceivable.new(customer_id: params[:customer_id])) 
  end

  def edit
    @receivable = Admin::ReceivablePresenter.new(AccountReceivable.find(params[:id])) 
  end

  def create
    @context = ReceivablesManagementContext.new(params, current_user)
    if @context.save_receivable
      redirect_to admin_customer_receivables_path, notice: "Conta a receber cadastrada."
    else
      @receivable = Admin::ReceivablePresenter.new(@context.resource)
      render :new
    end
  end

  def update
    
  end
end
