require 'spec_helper'

describe Admin::Api::CartsController do
  login_admin

  it_obeys_the "admin application controller contract"
  it_obeys_the "Decoration Builder contract"

  describe "POST create" do
    it "creates carts with embedded order items" do
      xhr :post, :create, { cart: {total: 0} }

      cart  = Cart.first
      json  = ActiveSupport::JSON.decode(response.body)

      json.should == {
        "cart" => {
          "id"    => cart.id,
          "total" => "0.0",
          "cart_item_ids" => []
        },
        "cart_items" => []
      }
    end
  end
end
