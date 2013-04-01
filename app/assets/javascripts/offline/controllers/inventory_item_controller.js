App.InventoryItemController = Ember.ArrayController.extend({

  // inventory items search
  searchQuery: null,

  searchDelay: null,

  // Triggered whenever the user presses a key in the search field
  queryChanged: function(value) {
    var that = this;

    this.controllerFor('carts.new').set('isOrderPlaced', false);

    clearTimeout(this.searchDelay);

    this.searchDelay = setTimeout(function() {
      var value = that.get('searchQuery');
      if (typeof value == "string" && value.length > 0) {
        searchResults = App.InventoryItem.find({
          search: that.searchQuery,
          on_sale: true
        });

        that.set('content', searchResults);
      } else
        that.set('content', null)

    }, 600);
  }.observes("searchQuery"),

  // User starts placing items in the cart
  addItem: function(inventory_item) {
    clearTimeout(this._cartCommitTimer);

    var new_cart_controller = this.controllerFor('carts.new'),
        cart = new_cart_controller.get('content');

    this.controllerFor('application').set('cartHasItems', true);

    var items = cart.get('items').createRecord({
      price: inventory_item.get('price'),
      inventory_item: inventory_item,
      inventory_entry_id: inventory_item.get('entry_for_sale_id')
    });

    new_cart_controller.updateItemsQuantityHeadline();

    // Delays the POST/PUT, so that requests don't step on each other's feet
    this._cartCommitTimer = setTimeout(function() {
      cart.get('store').commit();
    }, 2000);
  },

  addItemPressingEnter: function() {
    if (this.get('length') == 1)
      this.addItem(this.get('firstObject'));
  },

  // internal variables
  _cartCommitTimer: null
});
