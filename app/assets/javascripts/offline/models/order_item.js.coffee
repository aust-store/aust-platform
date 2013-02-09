App.OrderItem = DS.Model.extend
  price: attr('number')
  order: DS.belongsTo('App.Order', {embedded: 'always'})
  inventory_item: DS.belongsTo('App.InventoryItem')
  inventory_entry_id: attr('number')

  nameo: (->
    this.get('inventory_item.name')
  ).property("inventory_item.name")

App.Store.registerAdapter 'App.OrderItem', App.RESTAdapter.extend
  pluralize: -> 'order/item'
