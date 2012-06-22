# TODO unit test
require 'spec_helper'

describe Good do
  describe "#search_for", search: true do
    before do
      @good = Factory(:good, name: "The good and the bad", description: "Lorem ipsum")
    end

    it "should result the correct words by name" do
      result = Good.search_for "good", @good.company_id, page: 1, per_page: 1
      result.should include @good
    end

    it "should result the correct words by description" do
      result = Good.search_for "ipsum", @good.company_id, page: 1, per_page: 1
      result.should include @good
    end
  end
end
