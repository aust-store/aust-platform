module PostgresSearch
  class Search
    def initialize(model, options)
      @model = model
      @options = options
    end

    def search
      query = Query.new(model, options)
      where = query.where
      joins = query.joins
      order = query.order

      result = model
        .where(where, q: "#{keywords}:*")
        .order(order)
      result = result.joins(joins)
      result
    end

    private

    attr_accessor :model, :options

    def keywords
      options[:keywords].gsub(/\s/, " | ")
    end
  end
end
