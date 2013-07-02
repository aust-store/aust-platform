class SuperAdmin::StoresController < SuperAdmin::ApplicationController
  def index
    @stores = Company.all
  end
end
