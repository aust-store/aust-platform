App.CartsPaymentController = Ember.ArrayController.extend(
  App.SelectableListControllerMixin, {

  needs: ["application", "cartsNew"],

  init: function() {
    this._super();
    this.setSameAsCart();
  },

  setSameAsCart: function() {
    if (this.get('cart.paymentType.length')) {
      this.send('setSelection', this.findBy('id', this.get('cart.paymentType')));
    } else {
      this.resetSelection();
    }
  },

  cart: function() {
    return this.get('controllers.cartsNew');
  }.property(),

  actions: {
    markAsCurrent: function(type) {
      this.get('cart').set('paymentType', type.id);
      this.send('setSelection', type);
    }
  }
});
