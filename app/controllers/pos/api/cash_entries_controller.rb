# encoding: utf-8
class Pos::Api::CashEntriesController < Pos::Api::ApplicationController
  def index
    @resources = current_company.pos_cash_entries.order("pos_cash_entries.updated_at desc")

    only_current_user_resources
    search_by_date
    paginate_resource
    render json: @resources, meta: meta, root: "cash_entries"
  end

  def create
    @resource = current_company.pos_cash_entries.create(resource_params)
    if @resource.valid?
      render json: @resource, root: "cash_entry"
    else
      render json: @resource.errors.first_messages, root: "cash_entry"
    end
  end

  def update
    @resource = current_company.pos_cash_entries.find_by_uuid(params[:id])
    @resource.update_attributes(resource_params)
    render json: @resource, root: "cash_entry"
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
