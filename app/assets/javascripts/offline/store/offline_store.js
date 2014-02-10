var offlineAdapterConfig = {
  version: 5,
  migrations: function() {
    this.addModel(App.Cart);
    this.addModel(App.CartItem);
    this.addModel(App.Customer);
    this.addModel(App.InventoryItem);
    this.addModel(App.Order);
    this.addModel(App.OrderItem);
    this.addModel(App.StoreReport);
    this.addModel(App.CashEntry);

    this.addModel(App.EmberSyncQueueModel, {autoIncrement: true});
  },
};
App.ApplicationSerializer = DS.IndexedDBSerializer.extend();
App.ApplicationAdapter = DS.IndexedDBAdapter.extend({
  databaseName: "AustPointOfSale",
  version: offlineAdapterConfig.version,
  migrations: offlineAdapterConfig.migrations,
  smartSearch: true,

  generateIdForRecord: function() {
    return uuid.v4();
  },

  findQuerySearchCriteria: function(fieldName, type) {
    if (type.toString() == "App.InventoryItem" && fieldName == "description") {
      return false;
    } else {
      return true;
    }
  }
});
