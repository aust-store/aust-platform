module View
  module StoreTheme
    module TemplateElement

      # All data regarding the layout and rendering partials
      module LayoutAndRendering
        extend TemplateElementsDocumentation

        desc "yield"
        def yield
          raw content_for_layout
        end
      end
    end
  end
end
