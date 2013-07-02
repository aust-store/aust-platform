module ApplicationHelper
  # Navigation
  def current_nav_namespace(namespace = nil)
    raw 'class="current_namespace"' if @nav_namespace == namespace
  end

  # BUTTONS & ELEMENTS
  def small_button routing_resource, options
    has_image_class, image_styling = '', ''
    # has_image
    unless options[:image].blank?
      image_styling = 'style="background-image: url('+ asset_path(options[:image]) +')"'
      has_image_class = 'has_image'
    end

    # has_text
    unless options[:text].blank?
      text = options[:text]
      text_styling = 'text'
    end

    # has_image but no text
    if options[:text].blank? && !options[:image].blank?
      has_image_class = 'has_image_only'
    end
    
    options.delete(:text) unless options[:text].blank?
    options.delete(:image) unless options[:image].blank?

    options[:class] = "" unless options.has_key?(:class)
    options[:class] << ' css_button_anchor'
    if options.include?(:big)
      options[:class] << ' big round'
    else
      options[:class] << ' small'
    end
    
    button_content = '<span class="css_button '+ has_image_class +'" '+ image_styling +'>'
    button_content << '<span class="css_button_container '+ (text_styling || '') +'">'+ (text || '') +'</span>'
    button_content << '</span>'
    
    button = raw link_to(raw(button_content), routing_resource, options )
  end
  
  def big_button routing_resource, options
    options[:big] = true
    small_button routing_resource, options
  end
end
