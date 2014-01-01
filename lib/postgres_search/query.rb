module PostgresSearch
  class Query
    attr_accessor :joins, :model

    def initialize(model, query_options)
      @model = model
      @query_options = query_options
      @keywords = query_options[:keywords]
      @joins = []
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

    def joins
      @joins
    end

    def add_join_table(association)
      @joins << association
    end

    def model_sanitize
      model.sanitize(keywords)
    end

    private

    attr_accessor :query_options, :keywords

    def sql_where_statement(field_name)
      PostgresSearch::Where.new(self, field_name).to_s
    end

    def sql_order_statement(field_name)
      # "ts_rank(to_tsvector(#{table_name}.#{field}), plainto_tsquery(#{model_sanitize}))"
      PostgresSearch::Order.new(self, field_name).to_s
    end

    def table_name
      model.table_name
    end
  end
end
