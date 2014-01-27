require 'spec_helper'

describe Admin::Api::InventoryItemsController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "GET index" do
    before do
      @item             = FactoryGirl.create(:inventory_item, company: @company)
      @item_not_on_sale = FactoryGirl.create(:inventory_item_without_associations,
                                             company: @company)
      controller.stub(:items_per_page) { 1 }
    end

    it "returns all inventory items" do
      xhr :get, :index

      ActiveSupport::JSON.decode(response.body).should == {
        "meta" => {
          "page" => 1,
          "total_pages" => 2
        },
        "inventory_items" => [
          { "id"                => @item_not_on_sale.uuid,
            "name"              => @item_not_on_sale.name,
            "description"       => @item_not_on_sale.description,
            "price"             => 0,
            "entry_for_sale_id" => nil,
            "on_sale"           => false,
            "barcode"           => "123" }
      ]}

      xhr :get, :index, page: 2
      ActiveSupport::JSON.decode(response.body).should == {
        "meta" => {
          "page" => 2,
          "total_pages" => 2
        },
        "inventory_items" => [
          { "id"                => @item.uuid,
            "name"              => @item.name,
            "description"       => @item.description,
            "price"             => "12.34",
            "entry_for_sale_id" => @item.entry_for_sale.id,
            "on_sale"           => true,
            "barcode"           => "123" }
        ]
      }
    end

    it "returns only items on sale" do
      xhr :get, :index, on_sale: true

      ActiveSupport::JSON.decode(response.body).should == {
        "meta" => {
          "page" => 1,
          "total_pages" => 1
        },
        "inventory_items" => [
          { "id"                => @item.uuid,
            "name"              => @item.name,
            "description"       => @item.description,
            "price"             => "12.34",
            "entry_for_sale_id" => @item.entry_for_sale.id,
            "on_sale"           => true,
            "barcode"           => "123" }
        ]
      }
    end
  end
end
