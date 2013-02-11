App.InventoryItemController = Ember.ArrayController.extend
  searchQuery: null

  queryChanged: ((value) ->
    # fix after updating Ember.js. See bug #2035
    # this.controllerFor('carts_new').set('isOrderPlaced', false)

    value = this.get('searchQuery')
    if typeof value == "string" and value.length > 0
      this.set('content', App.InventoryItem.find({search: this.searchQuery}))
    else
      this.set('content', null)
  ).observes("searchQuery")

  addItem: (inventory_item) ->
    new_cart_controller = this.controllerFor('carts_new')

    cart = new_cart_controller.get('content')
    items = cart.get('items').createRecord
      price: inventory_item.get('price')
      inventory_item: inventory_item
      inventory_entry_id: inventory_item.get('entry_for_sale_id')

    cart.get('store').commit()

  addItemPressingEnter: ->
    if this.get('length') == 1
      this.addItem this.get('firstObject')
