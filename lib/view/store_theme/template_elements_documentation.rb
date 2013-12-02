require "ostruct"

module View
  module StoreTheme
    module TemplateElementsDocumentation
      @@documentation ||= {}

      def desc(method_name, options = {})
        translation = "mustache_commands.#{method_name}."
        name = I18n.t("#{translation}.name")
        description = I18n.t("#{translation}.description")

        @@documentation[name] = OpenStruct.new(
          description: description,
          original_name: method_name
        )
      end
    end
  end
end
