App.ApplicationController = Ember.Controller.extend
  newCart: ->
    cart_controller = this.controllerFor("carts.new")
    if cart_controller.get('content.items.length') > 0
      return unless confirm("Você tem certeza que deseja limpar o pedido atual?")

    cart_controller.resetCart()
    this.transitionTo("carts.new")

  cartHasItems: false
  cartStatusMessage: ""
