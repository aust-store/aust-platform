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
      include TemplateElement::LayoutAndRendering
      include TemplateElement::Company
      include TemplateElement::CompanyContact
      include TemplateElement::Cart
      include TemplateElement::Products
      include TemplateElement::Customer
      include TemplateElement::Pages
      include TemplateElement::Taxonomy
      include TemplateElement::Banners
      include TemplateElement::HtmlLinks
      include TemplateElement::RailsFlash

      def initialize(view, content_for_layout = nil)
        @view = view
        @content_for_layout = content_for_layout
        @documentation = {}

        # FIXME - remove this var
        #
        # We're using it because we can't change BannersHelper right now
        # because other themes (non-mustache) are using it
        @banners = view.banners if view.respond_to?(:banners)
      end

      # For resolving translated commands, like #company_name or #nome_da_empresa,
      # we rely on I18n.
      def respond_to?(method)
        super || command_present?(method)
      end

      # Say we have #company_name, in portuguese that would be #nome_da_empresa
      # according to our I18n. So, this reroutes existing translated methods,
      # such as {{{nome_da_empresa}}} to {{{company_name}}}.
      def method_missing(method, *args, &block)
        if command_present?(method)
          command_name = original_command_name(method)
          self.public_send(command_name, *args, &block)
        else
          super
        end
      end

    private

      attr_reader :view, :content_for_layout

      def controller
        view.controller
      end

      def controller_name
        controller.params[:controller]
      end

      def command_present?(command_name)
        theme_documentation.has_command?(command_name)
      end

      def original_command_name(translated_command_name)
        theme_documentation.original_method_name(translated_command_name)
      end

      def theme_documentation
        @theme_documentation ||= ThemeDocumentation.new
      end
    end
  end
end
