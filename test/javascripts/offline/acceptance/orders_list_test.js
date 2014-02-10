//= require offline_test_helper

module("Acceptance/Orders List", {
  setup: function() {
    setupEmberTest();
  }
});

var formatDate = function(date) {
  var year   = date.getFullYear(),
      month  = date.getMonth()+1,
      day    = date.getDate(),
      hour   = date.getHours(),
      minute = date.getMinutes();

  if (parseInt(hour) < 9)   { hour   = "0"+parseInt(hour); }
  if (parseInt(minute) < 9) { minute = "0"+parseInt(minute); }

  return day+"/"+month+"/"+year+", "+hour+":"+minute;
}

test("orders are listed in /orders", function() {
  visit("/orders");

  andThen(function() {
    var date = App.Order.FIXTURES.slice(-1)[0].createdAt,
        formattedDate = formatDate(date);

    equal(find(".total").text(), "R$ 10,00");
    equal(find(".created_at").text(), formattedDate);
    equal(find(".customer").text().trim(), "John Rambo");
  });
});

test("orders report shows up in /orders", function() {
  visit("/orders");

  andThen(function() {
    equal(find(".orders_statistics").text().trim(), "Total vendido hoje: R$ 3000,00");
  });
});
