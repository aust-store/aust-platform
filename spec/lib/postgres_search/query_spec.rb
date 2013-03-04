require "postgres_search/query"

describe PostgresSearch::Query do
  let(:model)   { double(table_name: "table_name") }
  let(:options) { {keywords: "Tony Montana", fields: [:name, :description]} }

  subject { described_class.new(model, options) }

  describe "#where" do
    it "returns the SQL string for both fields with an OR in between" do
      subject.where.should ==
        "to_tsvector('english', table_name.name) @@ to_tsquery(:q) or " + \
        "to_tsvector('english', table_name.description) @@ to_tsquery(:q)"
    end
  end

  describe "#order" do
    it "returns the SQL string for ordering the results" do
      model.stub(:sanitize).with("Tony Montana") { :sanitized }

      subject.order.should ==
        "ts_rank(to_tsvector(table_name.name), plainto_tsquery(sanitized)) + " + \
        "ts_rank(to_tsvector(table_name.description), plainto_tsquery(sanitized)) DESC"
    end
  end
end
