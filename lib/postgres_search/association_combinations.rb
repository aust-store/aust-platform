module PostgresSearch
  class AssociationCombinations
    def initialize(associations, query)
      @associations = associations
      @query = query
    end

    def combinations
      result = []
      associations.keys.each do |association|
        query.add_join_table(association)
        table = query.model.new.send("build_#{association}").class.table_name

        Array(associations[association]).each do |field|
          result << { table_name: table, field_name: field }
        end
      end
      result
    end

    private

    attr_reader :associations, :query
  end
end
