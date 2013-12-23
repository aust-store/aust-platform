App.CartsIndexController = Ember.ArrayController.extend
  setupController: (controller, model) ->
    controller.set('content', model)

App.CartsNewController = Ember.ObjectController.extend
  needs: ["application", "inventory_item"]

  whenOrderIsPlaced: ->
    this.resetCart()
    this.set('isOrderPlaced', true)

  resetCart: ->
    new_cart = this.store.createRecord('cart')
    this.get('controllers.application').set('cartHasItems', false)
    this.set('content', new_cart)
    this.get('controllers.inventory_item').set('searchQuery', null)
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
    this.get('controllers.application').set('cartStatusMessage', message)
  ).observes('items.length')

  # template properties
  isOrderPlaced: false
  itemsQuantityHeadline: "Itens no pedido"

  actions:
    # placing orders and managing post-commit
    placeOrder: ->
      return false unless confirm("Você quer realmente fechar o pedido?")

      order = this.store.createRecord('order', { cart: this.get('content') })
      order.on 'didCreate', => this.whenOrderIsPlaced()
      order.save()

