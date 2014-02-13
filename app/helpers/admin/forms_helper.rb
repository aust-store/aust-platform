module Admin::FormsHelper
  def taggable_input(field_name, form_object, taggable_model_scope)
    autocomplete = taggable_model_scope.all_tags.map { |t| {value: t.name, text: t.name} }
    form_object.input field_name,
      as: :string,
      required: false,
      input_html: {
        class: "js_taggable",
        data: {data: autocomplete.to_json}
      }
  end
end
