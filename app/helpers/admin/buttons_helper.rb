module Admin::ButtonsHelper
  def link_button_to(text, url, options = {})
    options.merge!({class: 'js_link_to', data: { url: url }})
    button_tag text, options
  end
end
