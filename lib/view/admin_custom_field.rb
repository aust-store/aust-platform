module View
  class AdminCustomField
    def initialize(resource, custom_field)
      @resource = resource
      @custom_field = custom_field
    end

    def render(form)
      options = send("options_for_#{custom_field.field_type}".to_sym)
      form.input custom_field.alphanumeric_name.to_sym, options
    end

    private

    attr_reader :resource, :custom_field

    def options_for_string
      {
        input_html: shared_input_html.merge({
          value: field_value
        }),
      }.merge(shared_options)
    end

    def options_for_radio
      { collection: custom_field.radio_values,
        as: :radio_buttons,
        checked: field_value,
        input_html: shared_input_html,
      }.merge(shared_options)
    end

    def shared_options
      { label: custom_field.name,
        required: false,
        hint: "Campo personalizado"
      }
    end

    def shared_input_html
      { class: "js_custom_field",
        data: {
          for_categories: custom_field.taxonomies.pluck(:id).join(",")
        }
      }
    end

    def field_value
      resource.custom_fields and
        resource.custom_fields[custom_field.alphanumeric_name]
    end
  end
end
