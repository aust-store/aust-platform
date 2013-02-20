# encoding: utf-8
class Admin::Api::ManufacturersController < Admin::Api::ApplicationController
  def index
    manufacturers = current_company.manufacturers
    manufacturers = search(manufacturers)
    manufacturers = limit(manufacturers)

    render json: manufacturers
  end

  private

  def search(manufacturers)
    manufacturers = manufacturers.search_for(params[:search]) if params[:search].present?
    manufacturers
  end

  def limit(manufacturers)
    manufacturers = manufacturers.limit(3)
    Rails.logger.info params.inspect
    if params[:limit].to_i.present? && params[:limit].to_i > 0
      manufacturers = manufacturers.limit(params[:limit].to_i)
    end
    manufacturers
  end
end
