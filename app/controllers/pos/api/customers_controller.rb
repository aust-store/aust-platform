class Pos::Api::CustomersController < Pos::Api::ApplicationController
  def index
    resource = current_company.customers
    resource = search(resource)
    resource = limit(resource).to_a

    render json: resource, root: "customers"
  end

  def create
    resource = current_company.customers.new(customer_params)
    if resource.save
      render json: resource, root: "customer"
    else
      render json: {errors: resource.errors.first_messages}, status: 422
    end
  end

  def update
    resource = current_company.customers.find_by_uuid(params[:id])
    if resource.update_attributes(customer_params)
      render json: resource, root: "customer"
    else
      render json: {errors: resource.errors.first_messages}, status: 422
    end
  end

  private

  def customer_params
    resource_params = params
      .require(:customer)
      .permit(:id, :first_name, :last_name, :email, :social_security_number)
      .merge(environment: "point_of_sale")

    replace_id_with_uuid(resource_params)
  end
end
