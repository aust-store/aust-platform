App.CashierIndexRoute = Ember.Route.extend({
  model: function() {
    var search = App.EmberSync.create({container: this});
    return search.findQuery('cashEntry', {createdAt: "today"});
  }
});

App.CashierNewRoute = Ember.Route.extend({
  model: function() {
    var search = App.EmberSync.create({container: this});
    return search.createRecord('cashEntry');
  }
});
