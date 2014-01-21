App.CartsNewController = Ember.ObjectController.extend({
  needs: ["application", "inventoryItem", "cartsCustomer"],

  whenOrderIsPlaced: function() {
    this.resetCart();
    this.set('isOrderPlaced', true);
  },

  resetCart: function() {
    var new_cart = this.store.createRecord('cart');

    this.get('controllers.application').set('cartHasItems', false);
    this.set('content', new_cart);
    this.get('controllers.inventoryItem').set('searchQuery', null);
    this.get('controllers.cartsCustomer').set('searchQuery', null);
    this.updateItemsQuantityHeadline();

    Ember.run(function() {
      $('#inventory_item_search').focus();
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
        message = "1 item no pedido";
      } else {
        message = quantity + " itens no pedido";
      }
    } else {
      message = "Itens no pedido";
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
          order;

      if (!confirm("Você quer realmente fechar o pedido?")) {
        return false;
      }

      var prop = {
        cart: this.get('content'),
        customer: this.get('content.customer'),
        createdAt: (new Date())
      };
      //order = this.store.createRecord('order', prop);

      var emberSync = App.EmberSync.create({container: this});
      order = emberSync.createRecord('order', prop);
      order.emberSync.save().then(function(order) {
        _this.whenOrderIsPlaced();
      });
    }
  }
});
