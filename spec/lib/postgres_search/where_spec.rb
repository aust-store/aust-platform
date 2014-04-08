require "postgres_search/where"

describe PostgresSearch::Where do
  let(:model) { double }
  let(:query) { double(model: model, model_sanitize: "sanitized_value") }
  let(:combinations) { double(combinations: [{
    table_name: :manufacturers,
    field_name: :name
  }, {
    table_name: :manufacturers,
    field_name: :description
  }]) }

  subject { described_class.new(query, field) }

  before do
    # ihul
    model.stub_chain(:new, :send, :class, :table_name) { "manufacturers" }
    query.stub(:add_join_table)

    stub_const("PostgresSearch::AssociationCombinations", Class.new)
    PostgresSearch::AssociationCombinations.stub(:new) { combinations }
  end

  describe "#to_s" do
    describe "with associations" do
      let(:field) { {manufacturer: [:name, :description]} }

      it "returns the correct where statement" do
        subject.to_s.should ==
          #"manufacturers.name ILIKE sanitized_value OR " + \
          "to_tsvector('english', coalesce(manufacturers.name, '')) @@ to_tsquery(:q) OR " + \
          #"manufacturers.description ILIKE sanitized_value OR " + \
          "to_tsvector('english', coalesce(manufacturers.description, '')) @@ to_tsquery(:q)"
      end
    end
  end
end
