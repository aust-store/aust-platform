require "models/extensions/full_text_search"

class DummySearch
  extend Models::Extensions::FullTextSearch

  def self.search_for(query)
    search do
      fields :name, :description
      keywords query
    end
  end
end

describe DummySearch do
  let(:pg_search) { double }

  before do
    stub_const("PostgresSearch::Search", Class.new)
  end

  describe ".search" do
    it "calls the class that's going to execute the Postgres FTS" do
      expected_request = {
        fields: [:name, :description],
        keywords: "Tony Montana"
      }

      PostgresSearch::Search
        .should_receive(:new)
        .with(DummySearch, expected_request)
        .and_return(double(search: :fts_results))

      described_class.search_for("Tony Montana").should == :fts_results
    end
  end
end
