module Admin::ErrorsHelper
  def output_error_messages(resources)
    return unless resources.errors.present?

    result = ""
    result += content_tag(:h2, "Erros")
    result += content_tag(:p, "Alguns campos precisam ser ajustados antes salvar este item.")
    resources.errors.messages.values.each do |errors|
      errors.each do |message|
        result += content_tag(:div, class: "error_message") { raw(message) }
      end
    end
    content_tag(:div, class: "errors_list") do
      raw result
    end
  end
end
