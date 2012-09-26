module ControllersExtensions
  module AdminApplication
    def current_user
      current_admin_user
    end
  end
end
