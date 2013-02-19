module PostgresSearch
  class Query
    def initialize(model, query_options)
      @model = model
      @query_options = query_options
      @keywords = query_options[:keywords]
    end

    def where
      where = []
      query_options[:fields].each do |field|
        where << sql_where_statement(field)
      end
      where.join(" or ")
    end

    def order
      order = []
      query_options[:fields].each do |field|
        order << sql_order_statement(field)
      end
      order.join(" + ") << " DESC"
    end

    private

    attr_accessor :model, :query_options, :keywords

    def sql_where_statement(field_name)
      "to_tsvector('english', #{table_name}.#{field_name}) @@ :q"
    end

    def sql_order_statement(field)
      "ts_rank(to_tsvector(#{field}), plainto_tsquery(#{model_sanitize}))"
    end

    def table_name
      model.table_name
    end

    def model_sanitize
      model.sanitize(keywords)
    end
  end
end
