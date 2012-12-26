module Store::UserRegistrationHelper
  def load_user_email
    params[:email].present? ? { value: params[:email] } : {}
  end
end
