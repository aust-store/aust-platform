App.CartItemsController = Ember.ArrayController.extend({
  needs: "cartsNew",

  cart: function() {
    return this.get('controllers.cartsNew');
  }.property("content.@each.cart.subtotal"),

  actions: {
    deleteItem: function(record) {
      var emberSync = App.EmberSync.create({container: this});
      emberSync.deleteRecord('cartItem', record);
      record.emberSync.save();
    }
  }
});
