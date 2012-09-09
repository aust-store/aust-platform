require 'spec_helper'

describe Good do
  describe "#search_for" do
    before do
      @good = FactoryGirl.create(:good_with_company,
                                 name: "The good and the bad",
                                 description: "Lorem ipsum")
    end

    it "should result the correct words by name" do
      result = Good.search_for "good", @good.company
      result.should include @good
    end

    it "should result the correct words by description" do
      result = Good.search_for "ipsum", @good.company
      result.should include @good
    end
  end
end
