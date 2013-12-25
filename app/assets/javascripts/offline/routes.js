App.Router.reopen({
  enableLogging: true,
  rootURL: '/'
});

App.Router.map(function() {
  this.resource('carts', function() {
    this.route('new');
  });
  this.resource('orders', function() { });
});

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('carts.new');
  }
});

App.CartsIndexRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('cart');
  }
});

App.CartsNewRoute = Ember.Route.extend({
  model: function() {
    current_model = this.controllerFor('carts.new').get('model');
    return current_model || this.store.createRecord('cart');
  },
});

App.OrdersIndexRoute = Ember.Route.extend({
  model: function() {
    var storeReport = this.store.find('storeReport');
    this.controllerFor("store_reports").set("model", storeReport);

    return this.store.find('order', {environment: "offline"});
  }
});
