//= require offline_test_helper

var apiUrl, statusUrl;

module("Integration/Api Route", {
  setup: function() {
    apiUrl = DS.CustomOnlineAdapter.create().namespace;
    statusUrl = serverStatusUrl;
  }
});

asyncTest("online API", function() {
  $.get(apiUrl + "/status")
  .done(function(response, status, xhr) {
    equal(xhr.getResponseHeader("Endpoint-Purpose"), "point_of_sale", apiUrl+"belongs to point of sale");
    start();
  })
  .fail(function() {
    ok(false, "URL is at "+apiUrl);
    start();
  });
});

asyncTest("online API status endpoint", function() {
  $.get(statusUrl)
  .done(function(response, status, xhr) {
    equal(xhr.getResponseHeader("Endpoint-Purpose"), "point_of_sale", apiUrl+"belongs to point of sale");
    start();
  })
  .fail(function() {
    ok(false, "URL is at "+apiUrl);
    start();
  });
});
