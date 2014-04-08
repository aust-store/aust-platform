require "postgres_search/query"
require "postgres_search/where"
require "postgres_search/order"

describe PostgresSearch::Query do
  let(:model)   { double(table_name: "cars", sanitize: "sanitized_value") }
  let(:fields)  { [:name, :description] }
  let(:options) { {keywords: "Tony Montana", fields: fields} }

  subject { described_class.new(model, options) }

  before do
    # ihul
    model.stub_chain(:new, :send, :class, :table_name) { "manufacturers" }
  end

  describe "#where" do
    describe "normal queries" do
      it "returns the SQL string for both fields with an OR in between" do
        subject.where.should ==
          "cars.name ILIKE sanitized_value OR " + \
          "to_tsvector('english', cars.name) @@ to_tsquery(:q) or " + \
          "cars.description ILIKE sanitized_value OR " + \
          "to_tsvector('english', cars.description) @@ to_tsquery(:q)"
      end
    end
  end

  describe "#order" do
    it "returns the SQL string for ordering the results" do
      model.stub(:sanitize).with("Tony Montana") { :sanitized }

      subject.order.should ==
        "ts_rank(to_tsvector(cars.name), plainto_tsquery(sanitized)) + " + \
        "ts_rank(to_tsvector(cars.description), plainto_tsquery(sanitized)) DESC"
    end
  end
end
