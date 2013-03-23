App.InventoryItemController = Ember.ArrayController.extend

  # inventory items search
  searchQuery: null

  queryChanged: ((value) ->
    this.controllerFor('carts.new').set('isOrderPlaced', false)

    value = this.get('searchQuery')
    if typeof value == "string" and value.length > 0
      this.set('content', App.InventoryItem.find
        search: this.searchQuery
        on_sale: true
      )
    else
      this.set('content', null)
  ).observes("searchQuery")

  # placing items in the cart
  addItem: (inventory_item) ->
    clearTimeout this._cartCommitTimer

    new_cart_controller = this.controllerFor('carts.new')
    cart = new_cart_controller.get('content')
    this.controllerFor('application').set('cartHasItems', true)

    items = cart.get('items').createRecord
      price: inventory_item.get('price')
      inventory_item: inventory_item
      inventory_entry_id: inventory_item.get('entry_for_sale_id')

    new_cart_controller.updateItemsQuantityHeadline()

    # delays the POST/PUT, so that requests don't step on each other's feet
    this._cartCommitTimer = setTimeout ( =>
      cart.get('store').commit()
    ), 2000

  addItemPressingEnter: ->
    if this.get('length') == 1
      this.addItem this.get('firstObject')

  # internal variables
  _cartCommitTimer: null
