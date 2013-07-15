class Store::ContactController < Store::ApplicationController
  def new
    @contact = ContactForm.new
  end

  def create
    @contact = ContactForm.new(params[:contact_form].merge({to: company_email}))

    if @contact.deliver
      redirect_to success_contact_url
    else
      render :new
    end
  end

  private

  def company_email
    current_store.contact_email
  end
end
