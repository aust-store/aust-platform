module View
  module StoreTheme
    class Layout
      include ActionView::Helpers::OutputSafetyHelper

      def initialize(view, action_view_context = nil)
        @view = view
        @action_view_context = action_view_context
      end

      def layout_to_be_rendered
        if mustache_layout?
          template = View::StoreTheme::MustacheTemplate.new(view,
                                                            content_for_mustache_layout)
          { text: raw(template.render(mustache_template)) }
        else
          { template: "layouts/store/non_mustache_layout" }
        end
      end

      def mustache_layout?
        File.exists?(mustache_template_path)
      end

      private

      attr_reader :view, :action_view_context

      def mustache_template_path
        path =  [@view.theme_path]
        path << [@view.theme_name]
        path << ["layout.mustache"]
        path.join("/")
      end

      def mustache_template
        File.read(mustache_template_path)
      end

      def content_for_mustache_layout
        View::MustacheContentForLayout.new(view).content_for(:layout) || non_mustache_content
      end

      def non_mustache_content
        raise "ActionView context doesn't exist" unless action_view_context.present?
        action_view_context.content_for(:layout)
      end
    end
  end
end
