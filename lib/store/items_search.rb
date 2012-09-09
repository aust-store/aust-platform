module Store
  class ItemsSearch
    def initialize(model, query)
      @model = model
      @query = query
    end

    def search
      if valid_query?
        @model.where(sql_where_statement, q: "#{query}:*")
          .order(sql_order_statement)
      else
        @model.first(10)
      end
    end

  private

    def valid_query?
      !@query.empty? && @query.length > 2
    end

    def sql_where_statement
      "to_tsvector('english', name) @@ :q or " + \
      "to_tsvector('english', description) @@ :q"
    end

    def sql_order_statement
      rank = "ts_rank(to_tsvector(name), " + \
             "plainto_tsquery(#{@model.sanitize(query)}))"
      "#{rank} DESC"
    end

    def query
      @query.gsub(/\s/, " | ")
    end
  end
end
