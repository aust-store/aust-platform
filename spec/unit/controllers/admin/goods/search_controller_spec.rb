require "unit_spec_helper"
require "controllers/admin/goods/search_controller"

describe Admin::Goods::SearchController do
  subject { described_class.new }

  it_obeys_the "Good model contract"
  it_obeys_the "application controller contract"
  
  before do
    Good.stub(:search_for).and_return("result")
    subject.stub_chain(:current_user, :company_id) { 1 }
    subject.stub(:params) { {name: :name} }
  end

  describe "#for_adding_balance" do
    it "should search for goods" do
      Good.should_receive(:search_for).with(:name, 1, page: 1, per_page: 10)
      subject.for_adding_balance
    end

    it "generates the correct route path" do
      subject.should_receive(:new_admin_inventory_good_balance_path)
      subject.for_adding_balance
      subject.path.call(1)
    end
  end

  describe "#index" do
    it "should search for goods" do
      Good.should_receive(:search_for).with(:name, 1, page: 1, per_page: 10)
      subject.index
    end

    it "generates the correct route path" do
      subject.should_receive(:admin_inventory_good_path)
      subject.index
      subject.path.call(1)
    end
  end
end
