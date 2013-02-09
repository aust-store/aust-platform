App.InventoryItemController = Ember.ArrayController.extend
  searchQuery: null

  queryChanged: ((value) ->
    if value == ""
      this.searchQuery = null
    else
      this.set('content', App.InventoryItem.find({search: this.searchQuery}))
  ).observes("searchQuery")

  addItem: (inventory_item) ->
    cart = this.controllerFor('carts_new').get('content')
    items = cart.get('items').createRecord
      price: inventory_item.get('price')
      inventory_item: inventory_item
      inventory_entry_id: inventory_item.get('entry_for_sale_id')

    cart.get('store').commit()
