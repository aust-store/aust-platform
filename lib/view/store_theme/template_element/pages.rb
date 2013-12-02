module View
  module StoreTheme
    module TemplateElement

      # All data related to the pages is grouped here.
      #
      # This module will be used in a mustache template. Consider that we have
      # the following hypothetical placeholder in a view (e.g `layout.mustache`):
      #
      #   Welcome to {{{company_name}}}
      #
      # Mustache will call the method `company_name`, which is defined in
      # TemplateElement::Company, thus replacing the placeholder with the
      # actual value.
      #
      module Pages
        extend TemplateElementsDocumentation

        desc "pages", block: true
        def pages
          i18n_block = "mustache_commands.pages.block"
          view.pages.map do |page|
            { I18n.t("#{i18n_block}.name") => raw(page.title),
              I18n.t("#{i18n_block}.page_href") => raw(controller.page_path(page)),
              I18n.t("#{i18n_block}.current_page") => current_path_class(controller.page_url(page)) }
          end
        end

        private

        def current_path_class(path_id)
          Controllers::Url.new(controller).current_if_same_url(path_id)
        end
      end
    end
  end
end
