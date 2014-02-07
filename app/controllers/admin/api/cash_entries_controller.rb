# encoding: utf-8
class Admin::Api::CashEntriesController < Admin::Api::ApplicationController
  def index
    @resources = current_company.pos_cash_entries.order("pos_cash_entries.updated_at desc")

    only_current_user_resources
    search_by_date
    paginate_resource
    render json: @resources, meta: meta
  end

  def create
    @resource = current_company.pos_cash_entries.create(resource_params)
    if @resource.valid?
      render json: @resource
    else
      render json: @resource.errors.first_messages
    end
  end

  def update
    @resource = current_company.pos_cash_entries.find_by_uuid(params[:id])
    @resource.update_attributes(resource_params)
    render json: @resource
  end

  private

  def resource_params
    resource_params = params
      .require(:cash_entry)
      .permit(:id, :amount, :entry_type, :description, :created_at)

    resource_params.merge!(admin_user_id: current_user.id)

    replace_id_with_uuid(resource_params)
  end
end
