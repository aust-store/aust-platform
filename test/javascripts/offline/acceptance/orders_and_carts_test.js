// require offline_test_helper

var _confirm = window.confirm;

module("Acceptance/Cart and ordering", {
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
    var itemName = find("table.listing.inventory_items").text().trim();
    equal(itemName, "Ibanez", "Item name is found");
  });

  /**
   * Adds the found item to cart
   */
  ok(!find("a.place_order_button:visible").length, "Order button isn't present");
  click("table.listing.inventory_items a");

  andThen(function() {
    var orderButton = find("a.place_order_button:visible");
    ok(!orderButton.length, "Order button isn't present yet");
  });

  /**
   * Searches for customer name
   */
  fillIn("#customer_search", "Rambo");

  andThen(function() {
    var orderButton = find("a.place_order_button:visible"),
        customerLink = find(".search_result.customer").text().trim(),
        customerSearch = find("#customer_search:visible");

    equal(customerLink, "John Rambo", "Customer is found")

    ok(!orderButton.length,   "Order button isn't present yet");
    ok(customerSearch.length, "Customer search input is present");
  });

  click("a:contains('John Rambo')");

  andThen(function() {
    var orderButton = find("a.place_order_button:visible"),
        customerSearch = find("#customer_search:visible");

    ok(orderButton.length,     "Order button then shows up");
    ok(!customerSearch.length, "Customer search is hidden");
  });

  /**
   * Accepts the confirm dialog
   */
  equal(App.Order.FIXTURES.length, 1);
  window.confirm = function() { return true }
  andThen(function() {
    click("a.place_order_button");
  });

  andThen(function() {
    equal(App.Order.FIXTURES.length, 2);
  });
});
