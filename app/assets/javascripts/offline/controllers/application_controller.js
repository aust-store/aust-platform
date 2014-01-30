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

  noConnectionMessageBinding: "App.emberOffline.noConnectionMessage",
  connectionIsBackMessageBinding: "App.emberOffline.backOnlineMessage",

  actions: {
    newCart: function() {
      cartController = this.get("controllers.carts_new");
      if (cartController.get('content.cartItems.length') > 0)
        if (!confirm("Você tem certeza que deseja limpar o pedido atual?"))
          return false;

      cartController.resetCart();
      this.transitionToRoute("carts.new");
    },
  }
});
