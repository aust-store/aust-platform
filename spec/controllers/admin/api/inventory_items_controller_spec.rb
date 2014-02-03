require 'spec_helper'

describe Admin::Api::InventoryItemsController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "GET index" do
    before do
      @item_pos  = create(:inventory_item, point_of_sale: true, company: @company)
      @item_pos2 = create(:inventory_item, point_of_sale: true, on_sale: false, company: @company)
      @item_not_pos = create(:inventory_item_without_associations, company: @company)
      controller.stub(:items_per_page) { 1 }
    end

    it "returns all POS inventory items" do
      xhr :get, :index

      ActiveSupport::JSON.decode(response.body).should == {
        "inventory_items" => [
          { "id"                => @item_pos2.uuid,
            "name"              => @item_pos2.name,
            "description"       => @item_pos2.description,
            "price"             => "12.34",
            "entry_for_sale_id" => nil,
            "on_sale"           => false,
            "barcode"           => "123",
            "reference_number"   => "1234" }
        ],
        "meta" => {
          "page" => 1,
          "total_pages" => 2
        },
      }

      xhr :get, :index, page: 2
      ActiveSupport::JSON.decode(response.body).should == {
        "inventory_items" => [
          { "id"                => @item_pos.uuid,
            "name"              => @item_pos.name,
            "description"       => @item_pos.description,
            "price"             => "12.34",
            "entry_for_sale_id" => @item_pos.entry_for_point_of_sale.id,
            "on_sale"           => true,
            "barcode"           => "123",
            "reference_number"   => "1234" }
        ],
        "meta" => {
          "page" => 2,
          "total_pages" => 2
        },
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
          { "id"                => @item_pos.uuid,
            "name"              => @item_pos.name,
            "description"       => @item_pos.description,
            "price"             => "12.34",
            "entry_for_sale_id" => @item_pos.entry_for_point_of_sale.id,
            "on_sale"           => true,
            "barcode"           => "123",
            "reference_number"   => "1234" }
        ]
      }
    end
  end
end
