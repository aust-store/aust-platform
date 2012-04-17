# encoding: utf-8
class Admin::Financial::ReceivablesController < Admin::ApplicationController
  before_filter :filter_due_to, only: [:create, :upload]
  before_filter :filter_value, only: [:create, :upload]

  def index
    @receivables = Admin::ReceivablePresenter.map(AccountReceivable.all)
  end

  def new
    @receivable = AccountReceivable.new(customer_id: params[:customer_id])    
  end

  def create
    @receivable = AccountReceivable.new(params[:account_receivable])
    @receivable.customer_id = params[:customer_id]
    if @receivable.save
      redirect_to admin_customer_receivables_path, notice: "Conta a receber cadastrada."
    else
      render :new
    end
  end

  private

  def filter_due_to
    date = Date.strptime params[:account_receivable][:due_to], "%d/%m/%Y"
    params[:account_receivable][:due_to] = date.strftime("%Y/%m/%d")
  end

  def filter_value
    value = Store::Currency.to_float params[:account_receivable][:value]
    params[:account_receivable][:value] = value
  end
end
