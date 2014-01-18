var testAdapterConfig = {
  name: "indexeddb_adapter",
  version: 4,
  databaseName: "AustPointOfSaleTests",
  migrations: function() {
    this.addModel(App.Cart);
    this.addModel(App.CartItem);
    this.addModel(App.Customer);
    this.addModel(App.InventoryItem);
    this.addModel(App.Order);
    this.addModel(App.OrderItem);
    this.addModel(App.StoreReport);
    this.addModel(App.EmberSyncQueueModel, {autoIncrement: true});
  }
}
