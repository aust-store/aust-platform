App.CartItemsController = Ember.ArrayController.extend({
  needs: "cartsNew",

  subtotal: function() {
    return this.get('content.firstObject.cart.subtotal');
  }.property("@each.length"),

  actions: {
    deleteItem: function(record) {
      var emberSync = App.EmberSync.create({container: this});
      emberSync.deleteRecord('cartItem', record);
      record.emberSync.save();
    }
  }
});
