App.ApplicationController = Ember.Controller.extend({
  init: function() {
    this.signOutPath = routes.exit_path;
    this._super();
  },

  newCart: function() {
    cart_controller = this.controllerFor("carts.new");
    if (cart_controller.get('content.items.length') > 0)
      if (!confirm("Você tem certeza que deseja limpar o pedido atual?"))
        return false;

    cart_controller.resetCart();
    this.transitionTo("carts.new");
  },

  cartHasItems: false,
  cartStatusMessage: "",
  signOutPath: null
});
