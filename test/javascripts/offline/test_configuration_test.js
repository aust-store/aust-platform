//= require offline_test_helper

var appAdapter, store, onlineStore;

module("Tests setup");

test("should use IndexedDBAdapter for offline connections", function() {
  var adapterName, adapterDatabase;

  adapterName     = testAdapterConfig.name;
  adapterDatabase = testAdapterConfig.databaseName;

  equal(adapterName,     "indexeddb_adapter",    "adapter is correct");
  equal(adapterDatabase, "AustPointOfSaleTests", "database is correct");
});
