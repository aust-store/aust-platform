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
    this.resetCart()
    this.set('isOrderPlaced', true)

  resetCart: ->
    new_cart = App.Cart.createRecord()
    this.controllerFor('application').set('cartHasItems', false)
    this.set('content', new_cart)
    this.controllerFor('inventory_item').set('searchQuery', null)
    this.updateItemsQuantityHeadline()
    Ember.run => $('#inventory_item_search').focus()

  # template data logic
  updateItemsQuantityHeadline: ( ->
    quantity = this.get('items').get('length')

    if quantity > 0
      if quantity == 1
        message = "1 item no pedido"
      else
        message = "#{quantity} itens no pedido"
    else
      message = "Itens no pedido"

    this.set('itemsQuantityHeadline', message)
    this.controllerFor('application').set('cartStatusMessage', message)
  ).observes('items.length')

  # template properties
  isOrderPlaced: false
  itemsQuantityHeadline: "Itens no pedido"
