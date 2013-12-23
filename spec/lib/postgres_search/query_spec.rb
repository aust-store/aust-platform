require "postgres_search/query"

describe PostgresSearch::Query do
  let(:model)   { double(table_name: "cars") }
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
          "to_tsvector('english', cars.name) @@ to_tsquery(:q) or " + \
          "to_tsvector('english', cars.description) @@ to_tsquery(:q)"
      end
    end

    describe "query with associations" do
      let(:fields) { [:name, {manufacturer: :name}] }

      it "returns the SQL and also changes the used associations" do
        subject.where.should ==
          "to_tsvector('english', cars.name) @@ to_tsquery(:q) or " + \
          "to_tsvector('english', manufacturers.name) @@ to_tsquery(:q)"
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
