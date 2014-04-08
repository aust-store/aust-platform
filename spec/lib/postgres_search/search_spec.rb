require "postgres_search/search"
require "postgres_search/query"

describe PostgresSearch::Search do
  let(:model)   { double }
  let(:options) { {keywords: "Tony Montana"} }
  let(:query)   { double(where: :where, order: :order, joins: :joins) }

  subject { described_class.new(model, options) }

  before do
    PostgresSearch::Query.stub(:new).with(model, options) { query }
  end

  describe "#search" do
    it "searches for the given keywords" do
      model.should_receive(:where)
        .with(:where, q: "Tony | Montana:*")
        .and_return(double.as_null_object)

      subject.search
    end

    it "orders the search by name" do
      query.stub_chain(:includes, :references)
      order = double
      order.should_receive(:order).with(:order) { query }

      model.stub(:where).and_return(order)

      subject.search
    end

    it "returns the ARel object" do
      model.stub_chain(:where, :order, :includes, :references) { :arel }
      subject.search.should == :arel
    end
  end
end
