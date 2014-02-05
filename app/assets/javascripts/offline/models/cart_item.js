App.CartItem = DS.Model.extend({
  price:                attr('number'),
  priceForInstallments: attr('number'),
  inventoryEntryId:     attr('number'),
  cart:                 DS.belongsTo('cart'),
  inventoryItem:        DS.belongsTo('inventoryItem'),
});
