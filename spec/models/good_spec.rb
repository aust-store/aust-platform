require 'spec_helper'

describe Good do
  describe "#search_for" do
    let(:search) { double(search: :search) }

    it "results the correct words by name" do
      Store::ItemsSearch.should_receive(:new).with(Good, :good) { search }

      Good.search_for(:good).should == :search
    end
  end
end
