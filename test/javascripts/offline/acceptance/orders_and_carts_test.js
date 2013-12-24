// require offline_test_helper

var _confirm = window.confirm;

module("Acceptance/Orders' cart", {
  setup: function() {
    setupEmberTest();
  },

  teardown: function() {
    window.confirm = _confirm;
  }
});

test("it allows users to put an order", function() {
  visit("/");

  /**
   * Searches for items
   */
  fillIn("#inventory_item_search", "Ibanez");
  andThen(function() {
    equal(find("table.listing.inventory_items").text().trim(), "Ibanez");
  });

  /**
   * Adds the found item to cart
   */
  ok(!find("a.place_order_button:visible").length, "Order button isn't present");
  click("table.listing.inventory_items a");
  andThen(function() {
    ok(find("a.place_order_button:visible").length, "Order button is present");
  });

  /**
   * Accepts the confirm dialog
   */
  window.confirm = function() { return true }
  click("a.place_order_button");
});
