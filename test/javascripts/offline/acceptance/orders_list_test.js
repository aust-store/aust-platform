//= require offline_test_helper

module("Acceptance/Orders List", {
  setup: function() {
    // setupEmberTest();
  }
});

pending("orders are listed in /orders", function() {
  visit("/orders");

  andThen(function() {
    equal(find("h1").html(), "Todos os pedidos");
    equal(find(".total").text(), "R$ 10,00");
    equal(find(".created_at").text(), "11/10/2013, 12:13");
  });
});

pending("orders report shows up in /orders", function() {
  visit("/orders");

  andThen(function() {
    equal(find(".orders_statistics").text().trim(), "Total vendido hoje: R$ 3000,00");
  });
});
