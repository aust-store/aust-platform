module PostgresSearch
  class Search
    def initialize(model, options)
      @model = model
      @options = options
    end

    def search
      query = Query.new(model, options)
      where = query.where
      order = query.order

      model
        .where(where, q: "#{keywords}:*")
        .order(order)
    end

    private

    attr_accessor :model, :options

    def keywords
      options[:keywords].gsub(/\s/, " | ")
    end
  end
end
