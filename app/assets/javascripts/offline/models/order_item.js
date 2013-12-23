App.OrderItem = DS.Model.extend({
  price: attr('number'),
  order: DS.belongsTo('cart', {embedded: 'always'}),
  inventory_item: DS.belongsTo('inventory_item'),
  inventory_entry_id: attr('number'),
})

/*
App.Store.registerAdapter 'App.OrderItem', App.RESTAdapter.extend
  pluralize: -> 'order/item'
*/
