require "postgres_search/association_combinations"

describe PostgresSearch::AssociationCombinations do
  let(:associations) { {cars: [:name, :description]} }
  let(:model)        { double }
  let(:query)        { double(model: model) }

  subject { described_class.new(associations, query) }

  before do
    model.stub_chain(:new, :send, :class, :table_name) { "cars" }
    query.stub(:add_join_table)
  end

  describe "#combinations" do
    it "returns possible combinations for a hash" do
      subject.combinations.should == [{
        table_name: "cars", field_name: :name
      }, {
        table_name: "cars", field_name: :description
      }]
    end
  end
end
