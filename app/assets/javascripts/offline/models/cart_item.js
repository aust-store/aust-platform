App.CartItem = DS.Model.extend({
  price:            attr('number'),
  inventoryEntryId: attr('number'),
  cart:             DS.belongsTo('cart'),
  inventoryItem:    DS.belongsTo('inventoryItem'),
});
