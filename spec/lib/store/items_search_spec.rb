require "store/items_search.rb"

describe Store::ItemsSearch do
  let(:model) { double(sanitize: "keyword") }

  describe "#search_for" do
    describe "where a keyword is given" do
      describe "the keyword sanitizing and validity" do
        it "searches if keyword is more than 2 characters" do
          model.stub_chain(:where, :order) { :arel }
          Store::ItemsSearch.new(model, "key").search.should == :arel
        end

        it "replaces spaces with |" do
          model.should_receive(:where)
            .with("to_tsvector('english', name) @@ :q or " + \
                  "to_tsvector('english', description) @@ :q",
                  q: "keyword | keyword:*")
            .and_return(double.as_null_object)

          Store::ItemsSearch.new(model, "keyword keyword").search
        end
      end

      it "searches for the given keywords" do
        model.should_receive(:where)
          .with("to_tsvector('english', name) @@ :q or " + \
                "to_tsvector('english', description) @@ :q",
                q: "keyword:*")
          .and_return(double.as_null_object)

        Store::ItemsSearch.new(model, "keyword").search
      end

      it "orders the search by name" do
        order = double
        order.should_receive(:order)
          .with("ts_rank(to_tsvector(name), plainto_tsquery(keyword)) DESC")

        model.stub(:where).and_return(order)

        Store::ItemsSearch.new(model, "keyword").search
      end

      it "returns the ARel object" do
        model.stub_chain(:where, :order) { :arel }
        Store::ItemsSearch.new(model, "keyword").search.should == :arel
      end
    end

    describe "when no valid keyword was given" do
      it "returns first 10 rows" do
        model.stub(:first).with(10) { :arel }
        Store::ItemsSearch.new(model, "").search.should == :arel
      end

      it "returns first 10 rows if keyword is less than 3 characters" do
        model.stub(:first).with(10) { :arel }
        Store::ItemsSearch.new(model, "ke").search.should == :arel
      end
    end
  end
end
