module ControllersExtensions
  module Store
    module ViewObjects
      def self.included(base)
        base.before_filter :view_objects
      end

      def view_objects
        # TODO -  this var should be removed when we get rid of the ERB templates
        @theme = View::Theme.new(current_store.theme)
        @layout_constraints = View::LayoutConstraints.new(self)
        @store_view = View::Store.new(controller: self, company: @company)
      end
    end
  end
end
