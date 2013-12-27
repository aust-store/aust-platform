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

    Ember.run.later(function() {
      $('#inventory_item_search').focus();
    }, 50);
  },

  /**
   * template data logic
   */
  updateItemsQuantityHeadline: function() {
    var quantity = this.get('items').get('length'),
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
  }.observes('items.length'),

  defineOrderReadyToBePlaced: function() {
    if (this.get('content').isValid() )
      this.set('isOrderReadyToBePlaced', true);
    else
      this.set('isOrderReadyToBePlaced', false);
  }.observes('items.length', 'customer'),

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

      order = this.store.createRecord('order', {
        cart: this.get('content'),
        createdAt: new Date()
      });

      order.on('didCreate', function() {
        _this.whenOrderIsPlaced();
      });
      order.save();
    }
  }
});
