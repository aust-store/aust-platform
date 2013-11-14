module View
  module StoreTheme
    class MustacheTemplate < Mustache

      # Rails helpers
      include ActionView::Helpers::OutputSafetyHelper

      def initialize(view, content_for_layout = "")
        @view = view
        @content_for_layout = content_for_layout
      end

      # Mustache never calls `method_missing`, which doesn't allow us to
      # reroute mustache elements, like {{company_name}} to TemplateElements
      # class. We have to `respond_to?` to be able to reach that class.
      def respond_to?(method)
        super || template_elements.respond_to?(method)
      end

      def method_missing(method, *args, &block)
        template_elements.send(method, *args, &block)
      end

      def yield
        raw content_for_layout
      end

      def footer
        raw MustacheContentForLayout.new(view).content_for(:footer)
      end

      private

      attr_reader :view, :content_for_layout

      # Used to render ERB partials, such as `shared/_products`.
      #
      # e.g render_partial("shared/products", items: controller.products)
      #
      def render_partial(path, locals = {})
        raw theme_view.render(partial: path, locals: locals)
      end

      def controller
        view.controller
      end

      def controller_name
        controller.params[:controller]
      end

      def theme_view
        views_path = Rails.root.join("app", "views")
        @theme_view ||= ThemeActionView.new(views_path, {}, controller)
      end

      def template_elements
        @template_elements ||= TemplateElements.new(view)
      end

      class ThemeActionView < ActionView::Base
        include ActionView::Helpers::UrlHelper
        include ActionView::Helpers::TagHelper
        include ActionView::Helpers::AssetTagHelper
        include ActionView::Helpers::OutputSafetyHelper
        include Rails.application.routes.url_helpers
      end
    end
  end
end
