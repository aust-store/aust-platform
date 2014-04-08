module PostgresSearch
  class Where
    def initialize(query, field)
      @query = query
      @field = field
    end

    def to_s
      if field.is_a?(String) || field.is_a?(Symbol)
        where_string(query.model.table_name, field)
      elsif field.is_a?(Hash)
        query_for_association
          .map { |opt| where_string(opt[:table_name], opt[:field_name]) }
          .join(" OR ")
      end
    end

    private

    attr_reader :query, :field

    def query_for_association
      PostgresSearch::AssociationCombinations.new(field, query).combinations
    end

    def where_string(table_name, field_name)
      "#{table_name}.#{field_name} ILIKE #{query.model_sanitize} OR " + \
      "to_tsvector('english', #{table_name}.#{field_name}) @@ to_tsquery(:q)"
    end
  end
end
