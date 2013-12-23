App.InventoryItem = DS.Model.extend({
  name: attr('string'),
  description: attr('string'),
  price: attr('number'),
  entry_for_sale_id: attr('number'),
  on_sale: attr('boolean'),
});
