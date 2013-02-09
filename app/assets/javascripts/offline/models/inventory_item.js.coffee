App.InventoryItem = DS.Model.extend
  name: attr('string')
  price: attr('number')
  entry_for_sale_id: attr('number')
