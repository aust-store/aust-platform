module ControllersExtensions
  module Store
    module ViewObjects
      def self.included(base)
        base.before_filter :view_objects
      end

      def view_objects
        @theme = View::StoreTheme.new(current_store.theme)
        @layout_constraints = View::LayoutConstraints.new(self)
      end
    end
  end
end
