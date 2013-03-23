if (typeof App.Reports == "undefined")
  App.Reports = {};

App.OrdersStatistics = DS.Model.extend({
  revenue: DS.attr("string")
});

App.Store.registerAdapter(App.OrdersStatistics, App.ReportsAdapter.extend());
