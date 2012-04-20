class ReceivablesManagementContext
  attr_reader :resource

  def initialize(params, author)
    @params = params
    @author = author
  end

  def save_receivable
    sanitize_controller_params
    @resource = AccountReceivable.new(@params[:account_receivable])
    @resource.customer_id = @params[:customer_id]
    @resource.admin_user_id = @author
    @resource.save
  end

  private

  def sanitize_controller_params
    sanitize_date "due_to"
    sanitize_currency "value"
  end

  def sanitize_date(key)
    @params[:account_receivable][key].extend DateSanitizer
    @params[:account_receivable][key].parse_date_for_active_record!
  end

  def sanitize_currency(key)
    @params[:account_receivable][key].extend CurrencyParser
    @params[:account_receivable][key].to_float!
  end
end
