module View
  # FIXME - this is known around as View, but is more like a data repository,
  # routing the data requests to the proper classes (e.g controllers, models,
  # etc).
  #
  class Store
    attr_reader :controller

    def initialize(args)
      @company = args[:company]
      @controller = args[:controller]
    end

    def theme
      @theme ||= View::Theme.new(company.theme)
    end

    def theme_path
      "./app/templates/themes"
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
  end
end
