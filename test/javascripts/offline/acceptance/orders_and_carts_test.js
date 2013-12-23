// require offline_test_helper

module("Acceptance/Orders' cart", {
  setup: function() {
    //App.reset();
  }
});

pending("it allows users to put an order", function() {
  visit("/").then(function() {
    fillIn("#inventory_item_search", "Ibanez");
  });
});
