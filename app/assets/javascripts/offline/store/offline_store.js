App.ApplicationSerializer = DS.IndexedDBSerializer.extend();
App.ApplicationAdapter = DS.IndexedDBAdapter.extend({
  databaseName: "AustPointOfSale",
  version: 1,
  migrations: function() {
    var _this = this;
    Ember.run(function() {
      _this.addModel(App.Cart);
      _this.addModel(App.CartItem);
      _this.addModel(App.Customer);
      _this.addModel(App.InventoryItem);
      _this.addModel(App.Order);
      _this.addModel(App.OrderItem);
      _this.addModel(App.StoreReport);
    });
  },

  generateIdForRecord: function() {
    return uuid.v4();
  }
});
