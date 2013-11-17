class Admin::DashboardController < Admin::ApplicationController
  def index
    @commerce_website = Store::Policy::CommerceSetup.new(current_company)
  end
end
