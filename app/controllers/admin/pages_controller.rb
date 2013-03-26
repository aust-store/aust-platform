class Admin::PagesController < Admin::ApplicationController
  def index
    @pages = current_company.pages.all
  end

  def new
    @page = current_company.pages.new
  end

  def edit
    @page = current_company.pages.find(params[:id])
  end

  def create
    @page = current_company.pages.new(params[:page])
    @page.admin_user_id = current_user.id

    if @page.save
      redirect_to admin_pages_url and return
    else
      render "new"
    end
  end

  def update
    @page = current_company.pages.find(params[:id])

    if @page.update_attributes params[:page]
      redirect_to admin_pages_path
    else
      render "edit"
    end
  end

  def destroy
  end
end
