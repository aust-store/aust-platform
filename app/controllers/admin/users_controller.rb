class Admin::UsersController < Admin::ApplicationController
  before_filter :authenticate_admin_user!
  authorize_resource :admin_user

  def index
    @users = current_company.admin_users.all
  end

  def new
    @user = current_company.admin_users.new
    authorize! :new, @user
  end

  def create
    @user = current_company.admin_users.new(user_creation_parameters)
    authorize! :new, @user

    if @user.save
      redirect_to admin_users_url
    else
      render "new"
    end
  end

  def edit
    @user = current_company.admin_users.find(params[:id])
    authorize! :update, @user
  end

  def update
    @user = current_company.admin_users.find(params[:id])
    authorize! :update, @user

    if @user.update_attributes params[:admin_user]
      redirect_to admin_users_url
    else
      render "edit"
    end
  end

  def destroy
    @user = current_company.admin_users.find(params[:id])
    authorize! :destroy, @user

    if @user.destroy
      redirect_to admin_users_url
    else
      redirect_to admin_users_url, notice: "error message"
    end
  end

private

  def user_creation_parameters
    params[:admin_user].merge(role: "collaborator")
  end
end
