App.CashierIndexRoute = Ember.Route.extend({
  model: function() {
    var search = App.EmberSync.create({container: this}),
        todaysOrders;

    todaysOrders = search.findQuery('order', {created_at: "today", payment_type: "cash"});
    this.controllerFor("cashierIndex").set('todaysOrders', todaysOrders);

    return search.findQuery('cashEntry', {created_at: "today"});
  }
});

App.CashierNewRoute = Ember.Route.extend({
  model: function() {
    var search = App.EmberSync.create({container: this});
    return search.createRecord('cashEntry');
  }
});
