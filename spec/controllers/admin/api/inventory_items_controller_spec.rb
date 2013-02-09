require 'spec_helper'

describe Admin::Api::InventoryItemsController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "GET index" do
    it "assigns all items as @items" do

      item = FactoryGirl.create(:inventory_item, company: @company)
      item_not_on_sale = FactoryGirl.create(:inventory_item_without_associations,
                                            company: @company)

      xhr :get, :index

      json = ActiveSupport::JSON.decode(response.body)
      json.should == {
        "inventory_items" => [
          { "id"                 => item.id,
            "name"               => item.name,
            "description"        => item.description,
            "price"              => "20.0",
            "inventory_entry_id" => item.entry_for_sale.id,
            "on_sale"            => true }
        ]
      }
    end
  end
end
