class Admin::Offline::ApplicationController < Admin::ApplicationController
  layout "offline"

  skip_before_filter :admin_dashboard_redirections
end
