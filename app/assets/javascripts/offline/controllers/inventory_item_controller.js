App.InventoryItemController = Ember.ArrayController.extend({
  needs: ["application", "carts_new"],

  // inventory items search
  searchQuery: null,

  // Triggered whenever the user presses a key in the search field
  queryChanged: function(value) {
    var _this = this;

    this.get('controllers.carts_new').set('isOrderPlaced', false);

    Ember.run(this, function() {
      /**
       * This is a hack to fix 'set on destroyed object' error on tests with
       * App.reset();
       */
      if (this.isDestroyed) { return; }

      var value = _this.get('searchQuery');
      if (typeof value == "string" && value.length > 0) {
        var search = App.SearchOnline.create({container: _this});
        results = search.find('inventoryItem', { search: value, on_sale: true });

        if (_this)
          _this.set('content', results);
      } else {
        if (_this)
          _this.set('content', null);
      }
    });//, App.defaultSearchDelay);

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

      item = this.store.createRecord('cartItem', {
        price: inventoryItem.get('price'),
        inventoryItem: inventoryItem,
        inventoryEntryId: inventoryItem.get('entryForSaleId')
      });
      cart.get("cartItems").pushObject(item);

      return cart.save().then(function() {
        return item.save().then(null, function(error) {
          console.log("Error saving item cart");
        });
      }, function(error) {
        console.log("Error saving cart");
      });
    }
  }

});
