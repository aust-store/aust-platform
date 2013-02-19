require "postgres_search/search"
require "postgres_search/query"

describe PostgresSearch::Search do
  let(:model)   { double }
  let(:options) { {keywords: "Tony Montana"} }
  let(:query)   { double(where: :where, order: :order) }

  before do
    PostgresSearch::Query.stub(:new).with(model, options) { query }
  end

  describe "#search" do
    it "searches for the given keywords" do
      model.should_receive(:where)
        .with(:where, q: "Tony | Montana:*")
        .and_return(double.as_null_object)

      described_class.new(model, options).search
    end

    it "orders the search by name" do
      order = double
      order.should_receive(:order)
        .with(:order)

      model.stub(:where).and_return(order)

      described_class.new(model, options).search
    end

    it "returns the ARel object" do
      model.stub_chain(:where, :order) { :arel }
      described_class.new(model, options).search
    end
  end
end
