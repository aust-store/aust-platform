class Admin::Financial::ReceivablesController < Admin::ApplicationController
  def new
    @receivable = Receivable.new(customer_id: params[:customer_id])    
  end
end
