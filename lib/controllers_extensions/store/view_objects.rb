module ControllersExtensions
  module Store
    module ViewObjects
      def self.included(base)
        base.before_filter :view_objects
      end

      def view_objects
        @google_analytics = View::GoogleAnalytics.new(current_store, self)
        # TODO -  this var should be removed when we get rid of the ERB templates
        @theme = View::Theme.new(current_theme)
        @layout_constraints = View::LayoutConstraints.new(self)
        @store_view = View::Store.new(controller: self, company: @company, theme: @theme)
      end

      # Allows us to change what theme is going to be shown. In the case where
      # the user is editing the theme, he can preview that particular theme
      # just by settings an id in session[:preview_theme_id].
      def current_theme
        @current_theme ||= if session[:preview_theme_id].present?
                             Theme.accessible_for_company(current_store).find(session[:preview_theme_id])
                           else
                             current_store.theme
                           end
      end
    end
  end
end
