App.CartsNewController = Ember.ObjectController.extend({
  needs: [
    "application", "cartsInventoryItems", "cartsCustomer", "cartsPayment"
  ],

  whenOrderIsPlaced: function() {
    this.resetCart();
    this.set('isOrderPlaced', true);
  },

  resetCart: function() {
    var emberSync = App.EmberSync.create({container: this}),
        new_cart = emberSync.createRecord('cart');

    this.get('controllers.application').set('cartHasItems', false);
    this.set('content', new_cart);
    this.get('controllers.cartsInventoryItems').set('searchQuery', null);
    this.get('controllers.cartsCustomer').set('searchQuery', null);
    this.get('controllers.cartsPayment').setSameAsCart();
    this.updateItemsQuantityHeadline();

    Ember.run(function() {
      Ember.$('#inventory_item_search').focus();
    });
  },

  /**
   * template data logic
   */
  updateItemsQuantityHeadline: function() {
    var quantity = this.get('cartItems').get('length'),
        message;

    if (quantity > 0) {
      if (quantity == 1) {
        message = "1 item";
      } else {
        message = quantity + " itens";
      }
    } else {
      message = "";
    }

    this.set('itemsQuantityHeadline', message);
    this.get('controllers.application').set('cartStatusMessage', message);
  }.observes('cartItems.length'),

  defineOrderReadyToBePlaced: function() {
    if (this.get('content').isValid()) {
      this.set('isOrderReadyToBePlaced', true);
    } else {
      this.set('isOrderReadyToBePlaced', false);
    }
  }.observes('cartItems.length', 'customer'),

  /**
   * Template properties
   */
  isOrderPlaced: false,
  isOrderReadyToBePlaced: false,
  itemsQuantityHeadline: "Itens no pedido",

  actions: {
    /**
     * Placing orders and managing post-commit
     */
    placeOrder: function() {
      var _this = this,
          order, total;

      if (!confirm("Você quer realmente fechar o pedido?")) {
        return false;
      }

      if (this.get('content.paymentType') == "installments") {
        total = this.get('content.subtotalForInstallments');
      } else {
        total = this.get('content.subtotal');
      }

      var prop = {
        total: total,
        cart: this.get('content'),
        customer: this.get('content.customer'),
        paymentType: this.get('content.paymentType'),
        createdAt: (new Date())
      };

      var emberSync = App.EmberSync.create({container: this});
      order = emberSync.createRecord('order', prop);
      order.emberSync.save().then(function(order) {
        _this.whenOrderIsPlaced();
      });
    }
  }
});
