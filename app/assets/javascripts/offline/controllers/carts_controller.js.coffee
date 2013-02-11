App.CartsIndexController = Ember.ArrayController.extend
  setupController: (controller, model) ->
    controller.set('content', model)

App.CartsNewController = Ember.ObjectController.extend

  # placing orders and managing post-commit
  placeOrder: ->
    return false unless confirm("Você quer realmente fechar o pedido?")
    order = App.Order.createRecord({ cart: this.content })
    order.on 'didCreate', => this.whenOrderIsPlaced()
    order.get('store').commit()

  whenOrderIsPlaced: ->
    new_cart = App.Cart.createRecord()
    this.controllerFor('cartsNew').set('content', new_cart)
    this.set('content', new_cart)
    this.controllerFor('inventory_item').set('searchQuery', null)

    setTimeout ( =>
      this.set('isOrderPlaced', false)
    ), 4000

    this.set('isOrderPlaced', true)
    Ember.run =>
      $('#inventory_item_search').focus()

  # template properties
  isOrderPlaced: false
