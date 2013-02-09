App.InventoryItemController = Ember.ArrayController.extend
  searchQuery: null

  queryChanged: ((value) ->
    if value == ""
      this.searchQuery = null
    else
      this.set('content', App.InventoryItem.find({search: this.searchQuery}))
  ).observes("searchQuery")

  addItem: (inventory_item) ->
    order = this.controllerFor('orders_new').get('content')
    items = order.get('items').createRecord
      price: inventory_item.get('price')
      inventory_item: inventory_item
      inventory_entry_id: inventory_item.get('entry_for_sale_id')

    order.get('store').commit()
