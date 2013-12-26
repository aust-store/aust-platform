require "postgres_search/where"

describe PostgresSearch::Where do
  let(:model) { double }
  let(:query) { double(model: model) }

  subject { described_class.new(query, field) }

  before do
    # ihul
    model.stub_chain(:new, :send, :class, :table_name) { "manufacturers" }
    query.stub(:add_join_table)
  end

  describe "#to_s" do
    describe "with associations" do
      let(:field) { {manufacturer: [:name, :description]} }

      it "returns the correct where statement" do
        subject.to_s.should ==
          "to_tsvector('english', manufacturers.name) @@ to_tsquery(:q) OR " + \
          "to_tsvector('english', manufacturers.description) @@ to_tsquery(:q)"
      end
    end
  end
end
