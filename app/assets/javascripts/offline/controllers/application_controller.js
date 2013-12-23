App.ApplicationController = Ember.Controller.extend({
  needs: ["carts_new"],

  init: function() {
    if (typeof routes !== "undefined") {
      this.signOutPath = routes.exit_path;
    }

    this._super();
  },

  cartHasItems: false,
  cartStatusMessage: "",
  signOutPath: null,

  actions: {
    newCart: function() {
      cart_controller = this.get("controllers.carts_new");
      if (cart_controller.get('content.items.length') > 0)
        if (!confirm("Você tem certeza que deseja limpar o pedido atual?"))
          return false;

      cart_controller.resetCart();
      this.transitionToRoute("carts.new");
    },
  }
});
