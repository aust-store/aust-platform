class Admin::BannersController < Admin::ApplicationController

  def index
    @banners = current_company.banners.page(params[:page])
  end

  def new
    @banner = load_banner
  end

  def create
    @banner = current_company.banners.new(params[:banner])
    if @banner.save
      redirect_to admin_banners_url
    else
      render :new
    end
  end

  def update
    @banner = load_banner
  end

  def edit
    @banner = load_banner
  end

  def update
    @banner = current_company.banners.find(params[:id])
    if @banner.update_attributes(params[:banner])
      redirect_to admin_banners_path
    else
      render :edit
    end
  end

  def destroy
    @banner = load_banner
    @banner.destroy

    redirect_to admin_banners_url
  end

  private

  def load_banner
    return current_company.banners.find(params[:id]) if params[:id]
    @banner ||= Banner.new(company: current_company)
  end

end
