require "ostruct"

module View
  module StoreTheme
    module TemplateElementsDocumentation
      @@documentation = {}

      def desc(method_name, options = {})
        method_name = method_name.to_s
        block = options[:block]

        translation = "mustache_commands.#{method_name}."
        name = I18n.t("#{translation}.name")
        description = I18n.t("#{translation}.description")
        group = I18n.t("#{translation}.group")
        type = I18n.t("#{translation}.type")

        if block
          command = "{{##{name}}} HTML {{/#{name}}}"
        else
          command = "{{{#{name}}}}"
        end

        @@documentation[name] = OpenStruct.new(
          command: command,
          description: description,
          original_name: method_name,
          group: group,
          type: type
        )
      end

      def documentation
        @@documentation
      end
    end
  end
end
