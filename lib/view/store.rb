module View
  # FIXME - this is known around as View, but is more like a data repository,
  # routing the data requests to the proper classes (e.g controllers, models,
  # etc).
  #
  class Store
    attr_reader :controller, :theme

    def initialize(args)
      @args = args
      @company = args[:company]
      @controller = args[:controller]
    end

    # Returns the path of the
    def theme_path
      theme.full_path
    end

    def theme_name
      theme.path
    end

    def company
      @company
    end

    def pages
      @company.pages.to_a
    end

    def taxonomy
      @company.taxonomies_as_hash
    end

    def products
      @controller.products
    end

    def product
      @controller.product
    end

    def banners
      @controller.banners
    end

    def contact_email?
      @company.contact_email.present?
    end

    def theme
      # Allow us to use a another theme for preview purposes. If it's not
      # present, uses the company's.
      @theme ||= @args.fetch(:theme, View::Theme.new(@company.theme))
    end
  end
end
