# encoding: utf-8
class Admin::Api::ManufacturersController < Admin::Api::ApplicationController
  def index
    manufacturers = current_company.manufacturers
    manufacturers = search(manufacturers)
    manufacturers = limit(manufacturers)

    render json: manufacturers
  end
end
