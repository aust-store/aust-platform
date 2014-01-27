// require offline_test_helper

var _confirm = window.confirm;

var env;

module("Acceptance/Cart and ordering", {
  setup: function() {
    EmberSync.testing = true;
    setupEmberTest();

    env = setupAcceptanceStoreEnv(App);
  },

  teardown: function() {
    window.confirm = _confirm;
  }
});

test("user puts order without existing customer", function() {
  visit("/");

  /**
   * Searches for item
   */
  fillIn("#inventory_item_search", "Ibanez");

  andThen(function() {
    var itemName = find("table.listing.inventory_items").text().trim();
    ok(itemName.match("Ibanez"), "Item name is found");
  });

  /**
   * Adds the found item to cart
   */
  ok(!find("a.place_order_button:visible").length, "Order button isn't present");
  click("table.listing.inventory_items a");

  andThen(function() {
    var orderButton = find("a.place_order_button:visible"),
        customerSearch = find("#customer_search:visible");

    ok(orderButton.length,    "Order button then shows up");
    ok(customerSearch.length, "Customer search is present");
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
    Em.run.later(function() {
      EmberSync.Queue.create({
        offlineStore: env.offlineStore,
        onlineStore:  env.onlineStore
      }).process();

      Em.run.later(function() {
        equal(App.Order.FIXTURES.length, 2);
      }, 110);
    }, 30);
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

  var prevTotalOrder = App.Order.FIXTURES.length,
      prevTotalCustomer = App.Customer.FIXTURES.length;

  andThen(function() {
    Em.run.later(function() {
      EmberSync.Queue.create({
        offlineStore: env.offlineStore,
        onlineStore:  env.onlineStore,
      }).process();

      Em.run.later(function() {
        var lastOrder, lastCustomer;

        equal(App.Order.FIXTURES.length, prevTotalOrder+1, "Order was created");

        lastOrder    = App.Order.FIXTURES.slice(-1)[0];
        lastCustomer = App.Customer.FIXTURES.slice(-1)[0];

        equal(lastOrder.customer.id, lastCustomer.id, "Order customer was added");
        env.onlineStore.find('customer', lastCustomer.id).then(function(customer) {
          equal(customer.get('firstName'), "John", "customer name");
          equal(customer.get('lastName'),  "Rambo", "customer last name");
          equal(customer.get('email'), "john.rambino@gmail.com", "customer email");
          equal(customer.get('socialSecurityNumber'), "Rambo", "customer CPF");
        });
      }, 120);
    }, 30);
  });
});
