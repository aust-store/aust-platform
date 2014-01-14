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

    this.render('carts/customer', {
      into: "carts.new",
      outlet: 'cartCustomer',
      controller: this.controllerFor('cartsCustomer')
    });
  },
});
