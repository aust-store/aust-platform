App.OrderItem = DS.Model.extend
  price: attr('number')
  order: DS.belongsTo('App.Cart', {embedded: 'always'})
  inventory_item: DS.belongsTo('App.InventoryItem')
  inventory_entry_id: attr('number')

App.Store.registerAdapter 'App.OrderItem', App.RESTAdapter.extend
  pluralize: -> 'order/item'
