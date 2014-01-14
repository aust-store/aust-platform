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

test("user puts order with existing customer", function() {
  visit("/");

  /**
   * Searches for item
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

  /**
   * Adds customer to cart
   */
  click("a:contains('John Rambo')");
  wait();

  andThen(function() {
    var orderButton = find("a.place_order_button:visible"),
        customerSearch = find("#customer_search:visible");

    ok(orderButton.length,     "Order button then shows up");
    ok(!customerSearch.length, "Customer search is hidden after selecting one");
  });

  /**
   * Puts the order and accepts the confirm dialog
   */
  equal(App.Order.FIXTURES.length, 1, "No order is saved before being confirmed");
  window.confirm = function() { return true }
  andThen(function() {
    click("a.place_order_button");
  });

  andThen(function() {
    //equal(App.Order.FIXTURES.length, 2);
  });
});

test("user puts order creating new customer", function() {
  visit("/");
  // Searches for item
  fillIn("#inventory_item_search", "Ibanez");
  // Adds the found item to cart
  click("table.listing.inventory_items a");

  // Searches for customer name
  fillIn("#customer_search", "Rambo");

  // Adds customer to cart
  click("a#show_customer_form");

  andThen(function() {
    var newCustomerForm = find(".new_customer_form:visible");
        firstNameInput  = find("form input[name='firstName']:visible"),
        lastNameInput   = find("form input[name='lastName']:visible"),
        emailInput      = find("form input[name='email']:visible"),
        socialNumber    = find("form input[name='socialSecurityNumber']:visible");

    ok(newCustomerForm.length, "Customer creation form is visible");
    ok(firstNameInput.length,  "Customer's first name input shows up");
    ok(lastNameInput.length,   "Customer's last name input shows up");
    ok(emailInput.length,      "Customer's email input shows up");
    ok(socialNumber.length,    "Customer's social number input shows up");
  });

  fillIn("form input[name='firstName']",            "John");
  fillIn("form input[name='lastName']",             "Rambo");
  fillIn("form input[name='email']",                "john.rambino@gmail.com");
  fillIn("form input[name='socialSecurityNumber']", "Rambo");
  click(".js_submit_customer");

  andThen(function() {
    var orderButton = find("a.place_order_button:visible"),
        customerSearch = find("#customer_search:visible"),
        newCustomerForm = find(".new_customer_form:visible");

    ok(orderButton.length,      "Order button then shows up");
    ok(!customerSearch.length,  "Customer search is hidden");
    ok(!newCustomerForm.length, "Customer creation form is hidden");
  });

  /**
   * Puts the order and accepts the confirm dialog
   */
  equal(App.Order.FIXTURES.length, 1, "Online has only one record");
  window.confirm = function() { return true }
  andThen(function() {
    click("a.place_order_button");
  });

  andThen(function() {
    //equal(App.Order.FIXTURES.length, 2);
  });
});
