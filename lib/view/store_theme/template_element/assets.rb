module View
  module StoreTheme
    module TemplateElement

      # All data related to assets (Javascript/CSS/images).
      #
      # For example, we use cloudfront as CDN. Now we can do something like
      #
      #     <img src"{{cdn}}site-name/images/logo.png" />
      #
      module Assets
        extend TemplateElementsDocumentation

        #desc :cdn
        def cdn
          "https://d17twk90t5po1q.cloudfront.net"
        end
      end
    end
  end
end
