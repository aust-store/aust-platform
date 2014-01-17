App.OrdersIndexRoute = Ember.Route.extend({
  model: function() {
    var search, storeReport;

    search = App.SearchOnline.create({container: this});
    storeReport = search.find('storeReport');
    this.controllerFor("storeReports").set("model", storeReport);

    results = search.findQuery('order', { environment: "offline" });
    return results;
  }
});
