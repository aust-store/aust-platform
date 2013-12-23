App.InventoryItemController = Ember.ArrayController.extend({
  needs: ["application", "carts_new"],

  // inventory items search
  searchQuery: null,

  searchDelay: null,

  // Triggered whenever the user presses a key in the search field
  queryChanged: function(value) {
    var _this = this;

    this.get('controllers.carts_new').set('isOrderPlaced', false);

    clearTimeout(this.searchDelay);

    this.searchDelay = setTimeout(function() {
      var value = _this.get('searchQuery');
      if (typeof value == "string" && value.length > 0) {
        searchResults = _this.store.find('inventory_item', {
          search: _this.searchQuery,
          on_sale: true
        });

        _this.set('content', searchResults);
      } else
        _this.set('content', null)

    }, 600);
  }.observes("searchQuery"),

  addItemPressingEnter: function() {
    if (this.get('length') == 1)
      this.addItem(this.get('firstObject'));
  },

  // internal variables
  _cartCommitTimer: null,

  actions: {
    // User starts placing items in the cart
    addItem: function(inventory_item) {
      clearTimeout(this._cartCommitTimer);

      var new_cart_controller = this.get('controllers.carts_new'),
          cart = new_cart_controller.get('content');

      this.get('controllers.application').set('cartHasItems', true);

      var items = cart.get('items').createRecord({
        price: inventory_item.get('price'),
        inventory_item: inventory_item,
        inventory_entry_id: inventory_item.get('entry_for_sale_id')
      });

      new_cart_controller.updateItemsQuantityHeadline();

      cart.save();
      //
      // Delays the POST/PUT, so that requests don't step on each other's feet
      this._cartCommitTimer = setTimeout(function() {
      }, 1000);
    }
  }

});
