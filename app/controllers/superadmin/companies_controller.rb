class Superadmin::CompaniesController < Superadmin::ApplicationController
  layout "superadmin"

  def index
    @companies = Company.all
    @companies.each { |c| c.include_statistics }
    respond_to do |format|
      format.html { render }
      format.js   { render json: @companies }
    end
  end

  def show
    @company = Company.find(params[:id]).include_statistics
    respond_to do |format|
      format.html { render }
      format.js   { render json: @company }
    end
  end
end
