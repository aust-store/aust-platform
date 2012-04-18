# encoding: utf-8
class Admin::Financial::ReceivablesController < Admin::ApplicationController
  def index
    @receivables = Admin::ReceivablePresenter.map(AccountReceivable.all)
  end

  def new
    @receivable = AccountReceivable.new(customer_id: params[:customer_id])    
  end

  def create
    @context = ReceivablesManagementContext.new(params)
    if @context.save_receivable
      redirect_to admin_customer_receivables_path, notice: "Conta a receber cadastrada."
    else
      render :new
    end
  end
end
