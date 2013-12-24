//= require offline_test_helper

module("Acceptance/Orders List", {
  setup: function() {
    setupEmberTest();
  }
});

test("orders are listed in /orders", function() {
  visit("/orders");

  andThen(function() {
    equal(find("h1").html(), "Todos os pedidos");
    equal(find(".total").text(), "R$ 10,00");
    equal(find(".created_at").text(), "11/10/2013, 12:13");
  });
});
