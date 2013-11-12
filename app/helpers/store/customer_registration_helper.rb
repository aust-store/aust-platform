module Store::CustomerRegistrationHelper
  def load_customer_email
    params[:email].present? ? { value: params[:email] } : {}
  end
end
