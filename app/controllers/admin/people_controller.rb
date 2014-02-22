class Admin::PeopleController < Admin::ApplicationController
  before_filter :fetch_resources, only: [:show, :edit, :update, :destroy]

  def index
    @resources = current_company
     .people
     .order('first_name', 'last_name')
     .page(params[:page])
     .per(25)
  end

  def new
    @resource = Person.new
    @resource.addresses.build
    @resource.roles << Role.customer.first
  end

  def show
    @resource = PersonDecorator.decorate(@resource)
  end

  def edit
    @resource.addresses.build unless @resource.addresses.present?
  end

  def create
    resource_params = params[:person]
    @resource = current_company.people.new(resource_params)

    if resource_params[:password].blank?
      resource_params.delete("password")
      resource_params.delete("password_confirmation")
    end

    @resource.environment = "admin"

    if @resource.save_with_minimal_validation
      redirect_to admin_people_url
    else
      render :new
    end
  end

  def update
    params[:person][:role_ids] ||= []
    resource_params = params[:person]

    if resource_params[:password].blank?
      resource_params.delete("password")
      resource_params.delete("password_confirmation")
    end

    if @resource.update_attributes_with_minimal_validation(resource_params)
      redirect_to admin_person_url(@resource)
    else
      render :edit
    end
  end

  def destroy
    @resource.disable
    redirect_to admin_people_url, notice: I18n.t('admin.default_messages.delete.success')
  end

  private

  def fetch_resources
    @resource = current_company.people.find(params[:id])
  end
end
