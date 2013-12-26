App.CartsNewController = Ember.ObjectController.extend({
  needs: ["application", "inventory_item"],

  whenOrderIsPlaced: function() {
    this.resetCart();
    this.set('isOrderPlaced', true);
  },

  resetCart: function() {
    var new_cart = this.store.createRecord('cart');

    this.get('controllers.application').set('cartHasItems', false);
    this.set('content', new_cart);
    this.get('controllers.inventory_item').set('searchQuery', null);
    this.updateItemsQuantityHeadline();

    Ember.run(function() {
      $('#inventory_item_search').focus();
    });
  },

  /**
   * template data logic
   */
  updateItemsQuantityHeadline: function() {
    var quantity = this.get('items').get('length');

    if (quantity > 0) {
      if (quantity == 1) {
        message = "1 item no pedido";
      } else {
        message = "#{quantity} itens no pedido";
      }
    } else {
      message = "Itens no pedido";
    }

    this.set('itemsQuantityHeadline', message);
    this.get('controllers.application').set('cartStatusMessage', message);
  }.observes('items.length'),

  /**
   * Template properties
   */
  isOrderPlaced: false,
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

      order = this.store.createRecord('order', { cart: this.get('content') });
      order.on('didCreate', function() {
        _this.whenOrderIsPlaced();
      });
      order.save();
    }
  }
});
