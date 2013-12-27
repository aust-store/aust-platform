App.InventoryItemController = Ember.ArrayController.extend({
  needs: ["application", "carts_new"],

  // inventory items search
  searchQuery: null,

  searchDelay: null,

  // Triggered whenever the user presses a key in the search field
  queryChanged: function(value) {
    var _this = this;

    this.get('controllers.carts_new').set('isOrderPlaced', false);

    Ember.run.later(this, function() {
      /**
       * This is a hack to fix 'set on destroyed object' error on tests with
       * App.reset();
       */
      if (this.isDestroyed) { return; }

      var value = _this.get('searchQuery');
      if (typeof value == "string" && value.length > 0) {
        searchResults = _this.store.find('inventoryItem', {
          search: _this.searchQuery,
          on_sale: true
        });

        if (_this)
          _this.set('content', searchResults);
      } else {
        if (_this)
          _this.set('content', null);
      }
    }, 600);

  }.observes("searchQuery"),

  addItemPressingEnter: function() {
    if (this.get('length') == 1)
      this.addItem(this.get('firstObject'));
  },

  actions: {
    // User starts placing items in the cart
    addItem: function(inventoryItem) {
      var _this = this,
          new_cart_controller = this.get('controllers.carts_new'),
          cart = new_cart_controller.get('model'),
          item,
          SaveItem;

      this.get('controllers.application').set('cartHasItems', true);
      new_cart_controller.updateItemsQuantityHeadline();

      SaveItem = function(cart) {
        item = _this.store.createRecord('cartItem', {
          cart: cart,
          price: inventoryItem.get('price'),
          inventoryItem: inventoryItem,
          inventoryEntryId: inventoryItem.get('entryForSaleId')
        });

        return item.save();
      }

      if (cart.get("isDirty")) {
        cart.save().then(SaveItem, function(error) { cl(error); });
      } else {
        SaveItem(cart);
      }
    }
  }

});
