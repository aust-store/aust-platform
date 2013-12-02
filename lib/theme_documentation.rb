class ThemeDocumentation

  def mustache_documentation
    doc_class.class_variable_get("@@documentation")
  end

  def original_method_name(translated_method_name)
    mustache_documentation.find do |command_name, details|
      command_name.to_sym == translated_method_name.to_sym
    end[1].original_name.to_sym
  end

  def has_command?(command_name)
    mustache_documentation.has_key?(command_name.to_s)
  end

  private

  def doc_class
    View::StoreTheme::TemplateElementsDocumentation
  end
end
