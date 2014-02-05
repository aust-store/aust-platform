App.CartsIndexRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('cart');
  }
});

App.CartsNewRoute = Ember.Route.extend({
  model: function() {
    var _this = this,
        currentModel = this.controllerFor('cartsNew').get('model'),
        emberSync = App.EmberSync.create({container: this});

    this.createPaymentTypes();

    return currentModel || emberSync.createRecord('cart', {
      paymentType: _this.controllerFor('cartsPayment').get('content.firstObject.id')
    });
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

    this.render('carts/payment', {
      into: "carts.new",
      outlet: 'cartPayment',
      controller: this.controllerFor('cartsPayment')
    });
  },

  createPaymentTypes: function() {
    var _this = this,
        paymentTypes = [
          { id: "cash", name: "Dinheiro à vista" },
          { id: "installments", name: "A prazo" },
          { id: "debit", name: "Débito" },
          { id: "credit_card", name: "Cartão de crédito" }
        ];

    this.controllerFor('cartsPayment').set('content', []);
    paymentTypes.forEach(function(type) {
      type = Ember.Object.create(type);
      _this.controllerFor('cartsPayment').get('content').pushObject(type);
    });
  }
});
