App.InventoryItem = DS.Model.extend({
  name: attr('string'),
  description: attr('string'),
  price: attr('number'),
  entryForSaleId: attr('number'),
  onSale: attr('boolean'),
  barcode: attr('string'),
});
