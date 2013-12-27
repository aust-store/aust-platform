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
    var current_model = this.controllerFor('cartsNew').get('model');
    return current_model || this.store.createRecord('cart');
  },

  renderTemplate: function() {
    this.render();
    this.render('inventoryItem', {
      into: "carts.new",
      outlet: 'inventoryItemSearch',
      controller: this.controllerFor('inventoryItem')
    });
  },
});

App.OrdersIndexRoute = Ember.Route.extend({
  model: function() {
    var storeReport = this.store.find('storeReport');
    this.controllerFor("storeReports").set("model", storeReport);

    return this.store.find('order', {environment: "offline"});
  }
});
