module Store::PersonRegistrationHelper
  def load_person_email
    params[:email].present? ? { value: params[:email] } : {}
  end
end
