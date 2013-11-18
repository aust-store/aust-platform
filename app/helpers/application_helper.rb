module ApplicationHelper
  # Navigation
  def current_nav_namespace(namespace = nil)
    raw 'class="current_namespace"' if @nav_namespace == namespace
  end

  # BUTTONS & ELEMENTS
  def small_button(text, routing_resource, options = {})
    button_classes = []

    # has_image
    unless options[:image].blank?
      options[:style] = "background-image: url(#{asset_path(options[:image])})"
      button_classes << 'has_image'
    end

    # has no text
    button_classes << "no_text" if text.blank?

    options.delete(:image) unless options[:image].blank?

    options[:class] = "" unless options.has_key?(:class)
    options[:class] << " #{button_classes.join(" ")}"
    options[:class] << " btn"

    raw link_to(raw(text), routing_resource, options)
  end

  def view_header(options = {})
    back_to   = options.fetch(:back_to,   "javascript: history.back()")
    back_text = options.fetch(:back_text, t("back"))

    locals = {
      back_to: back_to,
      text:    back_text
    }

    result =  render(partial: "layouts/admin/nav_history", locals: locals)
    result << render(partial: "layouts/admin/notices")
    result
  end
end
