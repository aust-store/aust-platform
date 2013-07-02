module View
  class StoreTheme
    def initialize(theme)
      @theme = theme
    end

    def method_missing(method, *args, &block)
      if @theme.respond_to?(method)
        @theme.send(method, *args, &block)
      else
        super
      end
    end

    def has_feature?(feature_name)
      @theme.respond_to?(feature_name.to_sym) && @theme.send(feature_name)
    end
    # In html, if a feature is present in the theme, e.g vertical taxonomy menu,
    # we want to output a classname such as "vertical_taxonomy_menu" so that we
    # can write as CSS properly.
    #
    # This returns either a string with the name of the feature or nil
    def feature_as_class(feature_name)
      "with_#{feature_name.to_s}" if has_feature?(feature_name)
    end
  end
end
