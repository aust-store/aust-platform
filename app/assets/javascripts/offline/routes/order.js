App.OrdersIndexRoute = Ember.Route.extend({
  model: function() {
    var storeReport = this.store.find('storeReport');
    this.controllerFor("storeReports").set("model", storeReport);

    return this.store.find('order', {environment: "offline"});
  }
});
