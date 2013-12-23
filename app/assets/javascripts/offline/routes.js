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
    return this.store.find('order', {environment: "offline"});
  },

  setupController2: function(controller, model) {
    controller.set('content', model);

    orders_statistics = this.store.find('orders_statistics', {period: "today"});
    this.controllerFor("orders_statistics").set("content", orders_statistics);
  },

  renderTemplate2: function() {
    this.render();
    this.render('orders_statistics', {
      outlet: 'orders_statistics',
      controller: 'orders_statistics'
    });
  }
});
