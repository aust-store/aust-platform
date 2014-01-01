require "spec_helper"

describe PostgresSearch::Order do
  let(:model) { double(table_name: "cars") }
  let(:query) { double(model: model, model_sanitize: "sanitized") }

  subject { described_class.new(query, field) }

  before do
    model.stub_chain(:new, :send, :class, :table_name) { "manufacturers" }
    query.stub(:add_join_table)
  end

  describe "#to_s" do
    describe "without associations" do
      let(:field) { :name }

      it "returns the correct where statement" do
        subject.to_s.should ==
          "ts_rank(to_tsvector(cars.name), plainto_tsquery(sanitized))"
      end
    end

    describe "with associations" do
      let(:field) { {manufacturer: [:name, :description]} }

      it "returns the correct where statement" do
        subject.to_s.should ==
          "ts_rank(to_tsvector(manufacturers.name), plainto_tsquery(sanitized)), " + \
          "ts_rank(to_tsvector(manufacturers.description), plainto_tsquery(sanitized))"
      end

      it "includes association in the list of join tables" do
        query.should_receive(:add_join_table).with(:manufacturer)
        subject.to_s
      end
    end
  end
end
