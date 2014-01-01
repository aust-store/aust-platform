module PostgresSearch
  class Order
    def initialize(query, field)
      @query = query
      @field = field
    end

    def to_s
      if field.is_a?(String) || field.is_a?(Symbol)
        order_string(query.model.table_name, field)
      elsif field.is_a?(Hash)
        query_for_association
          .map { |opt| order_string(opt[:table_name], opt[:field_name]) }
          .join(", ")
      end
    end

    private

    attr_reader :query, :field

    def query_for_association
      PostgresSearch::AssociationCombinations.new(field, query).combinations
    end

    def order_string(table_name, field_name)
      "ts_rank(to_tsvector(#{table_name}.#{field_name}), plainto_tsquery(#{query.model_sanitize}))"
    end
  end
end
