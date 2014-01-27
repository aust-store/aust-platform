App.CartsIndexRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('cart');
  }
});

App.CartsNewRoute = Ember.Route.extend({
  model: function() {
    var currentModel = this.controllerFor('cartsNew').get('model'),
        emberSync = App.EmberSync.create({container: this});

    return currentModel || emberSync.createRecord('cart');
  },

  renderTemplate: function() {
    this.render();
    this.render('carts/inventoryItems', {
      into: "carts.new",
      outlet: 'inventoryItemSearch',
      controller: this.controllerFor('cartsInventoryItems')
    });

    this.render('carts/customer', {
      into: "carts.new",
      outlet: 'cartCustomer',
      controller: this.controllerFor('cartsCustomer')
    });
  },
});
