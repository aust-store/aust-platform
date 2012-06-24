require 'unit_spec_helper'
require "controllers/admin/goods_controller"

describe Admin::GoodsController do
  subject { Admin::GoodsController.new }

  it_obeys_the "application controller contract"
  it_obeys_the "Good model contract"

  before do
    subject.stub(:current_admin_user)
  end

  describe "#index" do
    it "assigns all goods as @goods" do
      subject.stub_chain(:current_user, :company) { 123 }
      Good.stub(:within_company).with(123) { double(all: "goods") }
      subject.index.should == "goods"
    end
  end

  describe "#show" do
    it "should return a single good" do
      subject.stub(:params) { {id: 123} }
      Good.stub(:find).with(123) { "good" }
      subject.show.should == "good"
    end
  end

  describe "#new" do
    it "should instantiate a good" do
      Good.stub(:new) { "new good"}
      subject.new.should == "new good"
    end
  end

  describe "#search" do
    # TODO two different mocks in the same test, meaning this method is
    # doing to much
    it "performs a search on Good" do
      subject.stub(:params) { {name: "name"} }
      subject.stub_chain(:current_user, :company_id) { "company_id" }
      Good.should_receive(:search_for)
          .with("name", "company_id", page: 1, per_page: 10)
      subject.search
    end

    it "renders search with no layout" do
      subject.stub_chain(:current_user, :company_id) { "company_id" }
      Good.stub(:search_for)
      subject.should_receive(:render).with("search", layout: false)
      subject.search
    end
  end

  describe "#edit" do
    it "should instantiate a given good" do
      subject.stub(:params) { {id: 1} }
      Good.stub(:find).with(1) { "good" }
      subject.edit.should == "good"
    end
  end

  describe "#create" do
    before do
      subject.stub(:params) { {good: "good"} }
      @good = double
      @good.stub(:user=)
      @good.stub(:company=)
      @good.stub(:save)
      @current_user = double(company: "company")
      subject.stub(:current_user).and_return(@current_user)
      Good.stub(:new) { @good }
    end

    # TODO this method has too much responsibility
    context "creating the good" do
      it "creates a new Good" do
        Good.should_receive(:new).with("good") { @good }
        subject.create
      end

      it "sets the good's user" do
        @good.should_receive(:user=).with(@current_user)
        subject.create
      end
      it "sets the good's company" do
        @good.should_receive(:company=).with("company")
        subject.create
      end
    end

    context "redirecting" do
      it "redirect to the inventory" do
        @good.stub(:save) { true }
        subject.stub(:admin_inventory_goods_url) { "admin_inventory" }
        subject.should_receive(:redirect_to).with("admin_inventory")
        subject.create
      end

      it "renders the form again" do
        @good.stub(:save) { false }
        subject.should_receive(:render).with("new")
        subject.create
      end
    end
  end

  describe "#update" do
    before do
      subject.stub(:params) { {id: 1, good: "good"} }
      @good = double
      Good.stub(:find).with(1) { @good }
    end

    it "should update attributes" do
      @good.should_receive(:update_attributes).with("good")
      subject.update
    end

    context "updating the good" do
      before do
        @good.stub(:update_attributes) { true }
        subject.stub(:admin_inventory_good_url).with(@good) { "good_page" }
      end

      describe "remotipart submitted" do
        it "renders when remotipart was submitted" do
          subject.stub(:remotipart_submitted?) { true }
          subject.should_receive(:render)
                 .with(partial: "shared/images", layout: false)
          subject.update
        end

        it "doesn't render when remotipart wasn't submitted" do
          subject.stub(:remotipart_submitted?) { false }
          subject.should_not_receive(:render)
          subject.update
        end
      end

      it "redirects to the goods page in the inventory" do
        subject.stub(:remotipart_submitted?)
        subject.stub(:admin_inventory_good_url).with(@good) { "good_page" }
        subject.should_receive(:redirect_to).with("good_page")
        subject.update
      end
    end

    context "not updating the good" do
      it "renders edit" do
        @good.stub(:update_attributes) { false }
        subject.should_receive(:render).with("edit")
        subject.update
      end
    end
  end

  describe "#destroy" do
    before do
      @good = double
      @good.stub(:destroy)
      subject.stub(:params) { {id: 1} }
      Good.stub(:find).with(1) { @good }
      subject.stub(:admin_inventory_goods_url) { "goods page" }
    end

    it "redirects when destroy is successful" do
      @good.stub(:destroy) { true }
      subject.should_receive(:redirect_to).with("goods page")
      subject.destroy
    end

    it "redirects with failure message when destroy isn't successful" do
      @good.stub(:destroy) { false }
      subject.should_receive(:redirect_to).with("goods page",
                                                failure: "error message")
      subject.destroy
    end
  end
end
