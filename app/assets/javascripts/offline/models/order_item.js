App.OrderItem = DS.Model.extend({
  name: attr('string'),
  price: attr('number'),
  priceForInstallments: attr('number'),
  quantity: attr('number'),
  order: DS.belongsTo('order'),
  inventory_item: DS.belongsTo('inventory_item'),
  inventory_entry_id: attr('number'),
});
