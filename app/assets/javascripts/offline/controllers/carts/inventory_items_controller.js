App.CartsInventoryItemsController = Ember.ArrayController.extend({
  needs: ["application", "carts_new"],
  itemController: 'cartsInventoryItem',

  init: function() {
    this._super();
  },

  // inventory items search
  searchQuery: null,

  resetSelection: function() {
    var selection = this.objectAt(0);
    this.setEach('isSelected', false);
    if (selection)
      selection.set('isSelected', true);
  }.observes("@each.id"),

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
        var search = App.EmberSync.create({container: _this});
        results = search.findQuery('inventoryItem', { search: value, onSale: true });

        if (_this) {
          _this.set('content', results);
        }
      } else {
        if (_this)
          _this.set('content', null);
      }
    });//, App.defaultSearchDelay);

  }.observes("searchQuery"),

  actions: {
    /**
     * TODO - can we move it into an external object to be reused?
     */
    changeSelection: function(params) {
      if (!params.hasOwnProperty("direction") || this.get('length') == 0) {
        return false;
      }

      var currentIndex = this.indexOf(this.findBy('isSelected', true) || -1),
          nextIndex = currentIndex + params.direction;

      this.setEach('isSelected', false);
      if (nextIndex == this.get('length')) {
        nextIndex = 0;
      } else if (nextIndex < 0) {
        nextIndex = this.get('length') - 1;
      }

      this.objectAt(nextIndex).set('isSelected', true);
    },

    addItemPressingEnter: function() {
      var selected = this.findBy('isSelected', true).get('content');

      if (this.get('length') >= 1 && selected) {
        this.send('addItem', selected);
      }
    },

    // User starts placing items in the cart
    addItem: function(inventoryItem) {
      var _this = this,
          newCartController = this.get('controllers.carts_new'),
          cart = newCartController.get('model'),
          emberSync = App.EmberSync.create({container: this}),
          cartItem, SaveItem;

      this.get('controllers.application').set('cartHasItems', true);
      newCartController.updateItemsQuantityHeadline();

      cartItem = emberSync.createRecord('cartItem', {
        price: inventoryItem.get('price'),
        inventoryItem: inventoryItem,
        inventoryEntryId: inventoryItem.get('entryForSaleId')
      });
      cart.get("cartItems").pushObject(cartItem);

      cart.emberSync.save().then(function(cart) {
        return cartItem.emberSync.save().then(null, function(error) {
          console.log("Error saving cart item");
        });
      }, function(error) {
        console.log("Error saving cart");
      });
    }
  }
});
