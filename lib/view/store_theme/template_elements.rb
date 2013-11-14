module View
  module StoreTheme
    class TemplateElements
      # Includes default Rails view helpers to allow us to call methods such
      # as `raw`, `link_to`, `url_for`, as well as routes, assets and others.
      include ActionView::Context
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::CaptureHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::OutputSafetyHelper
      include Rails.application.routes.url_helpers

      # Custom helpers
      include ::Store::NavigationHelper
      include ::Store::TaxonomyMenuHelper
      include ::BannersHelper

      # Here are the elements that are used in the store's page. Each method in
      # the module below are used to replace a Mustache placeholder.
      #
      # Consider that we have the following:
      #
      #   Welcome to {{{company_name}}}
      #
      # Mustache will call the method `company_name`, which is defined in
      # TemplateElement::Company, thus replacing the placeholder with the
      # actual value.
      #
      include TemplateElement::Company
      include TemplateElement::Cart
      include TemplateElement::Products
      include TemplateElement::Customer
      include TemplateElement::Pages
      include TemplateElement::Taxonomy
      include TemplateElement::Banners
      include TemplateElement::HtmlLinks
      include TemplateElement::RailsFlash

      def initialize(view)
        @view = view

        # FIXME - remove this var
        #
        # We're using it because we can't change BannersHelper right now
        # because other themes (non-mustache) are using it
        @banners = view.banners
      end

    private

      attr_reader :view

      def controller
        view.controller
      end

      def controller_name
        controller.params[:controller]
      end
    end
  end
end
