//= require offline_test_helper

var env = {}, emberSync,
    store, mock, onlineResults,
    onlineStore;

var Cart     = App.Cart,
    CartItem = App.CartItem,
    Customer = App.Customer,
    InventoryItem = App.InventoryItem;

module("Integration/Lib/EmberSync/OfflineCache", {
  setup: function() {
    mock = null;
    EmberSync.testing = true;

    stop();
    App.Cart = DS.Model.extend({
      total:     DS.attr('string'),
      cartItems: DS.hasMany('cartItem'),
      customer:  DS.belongsTo('customer'),
    });

    App.CartItem = DS.Model.extend({
      price: DS.attr('number'),
      cart:  DS.belongsTo('cart'),
    });

    App.Customer = DS.Model.extend({
      name: attr('number'),
      cart: DS.belongsTo('cart'),
    });

    App.InventoryItem = DS.Model.extend({
      name: attr('string'),
      description: DS.attr('string'),
      price: DS.attr('number'),
      entryForSaleId: DS.attr('number'),
      onSale: DS.attr('boolean'),
    });

    setupEmberTest();

    env = setupOfflineOnlineStore({
      cart:     App.Cart,
      cartItem: App.CartItem,
      customer: App.Customer,
      inventoryItem: App.Customer,
      emberSyncQueueModel: App.EmberSyncQueueModel
    });
    store = env.store;
    onlineStore = env.onlineStore;
    emberSync = App.EmberSync.create({ container: env });
    start();
  },

  teardown: function() {
    EmberSync.forceSyncFailure = false;

    App.Cart     = Cart;
    App.CartItem = CartItem;
    App.Customer = Customer;
    App.InventoryItem = InventoryItem;
  }
});

var StartQunit = function() { start(); }

var assertNoOfflineRecords = function(type) {
  var promise = store.findAll(type);

  return new Ember.RSVP.Promise(function(resolve, reject) {
    promise.then(function(found) {
      equal(found.get('length'), 0, "There are no records for "+type);
      resolve();
    }, function() {
      ok(false, "Error assert there are no records for "+type);
      resolve();
    });
  });
};

pending("#download pushes all jobs to the online store", function() {
  var onlineTotalRecords = App.InventoryItem.FIXTURES.length;
  stop();

  var TestThereIsNothingOffline = function() {
    return assertNoOfflineRecords('inventoryItem');
  };

  var StartDownload = function() {
    return new Ember.RSVP.Promise(function(resolve, reject) {
      emberSync.offlineCache({
        models: ['inventoryItem']
      });

      Ember.run.later(function() {
        resolve();
      }, 70);
    });
  };

  var TestDataWasCached = function() {
    return new Ember.RSVP.Promise(function(resolve, reject) {
      var promise = onlineStore.findAll('inventoryItem');

      promise.then(function(items) {
        var totalInventoryItemsOnline = App.InventoryItem.FIXTURES.length,
            item1 = items.object(0),
            item2 = items.object(1),
            item3 = items.object(2);

        equal(items.get('length'), totalInventoryItemsOnline, 'All items were downloaded');

        equal(item1.get('id'), "1", "Item1's id is correct");

        resolve();
      });
    });
  };

  TestThereIsNothingOffline().then(StartDownload)
                             .then(TestDataWasCached)
                             .then(StartQunit)
});
