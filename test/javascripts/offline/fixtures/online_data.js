/**
 * In the app, there are 2 stores, one for offline (using IndexedDB) and another
 * for online connection (using ActiveModel).
 *
 * This is the store and adapter used to simulate online connection under
 * tests using QUNIT.
 */
var registeredNameForOnlineAdapter = "_custom_fixture_adapter";

var CustomFixtureSerializer = DS.JSONSerializer.extend();
var CustomFixtureAdapter = DS.FixtureAdapter.extend({
  latency: 2,

  /**
   * Used for querying the Fixtures with this.store.find(...)
   */
  queryFixtures: function(records, query, type) {
    return records.filter(function(record) {
      for(var queryKey in query) {
        var value = query[queryKey];

        if (queryKey == "search") {
          for(var recordKey in record) {
            if (record[recordKey] === value) {
              return true;
            }
          }
        }

        if (!query.hasOwnProperty(queryKey)) {
          continue;
        }

        if (record[queryKey] !== value) {
          return false;
        }
      }
      return true;
    });
  }
});

DS.OnlineStore = DS.Store.extend({
  defaultAdapter: CustomFixtureAdapter,

  adapterFor: function(type) {
    return this.container.lookup('adapter:' + registeredNameForOnlineAdapter);
  },

  serializerFor: function(type) {
    return this.container.lookup('serializer:' + registeredNameForOnlineAdapter);
  }
});

var optionsForOnlineStore = {
  store: DS.OnlineStore,
  registeredName: registeredNameForOnlineAdapter,
  adapter: CustomFixtureAdapter,
  serializer: CustomFixtureSerializer
}

/**
 * Registers the store within Ember application
 */
Ember.onLoad('Ember.Application', function(Application) {
  Application.initializer({
    name: "onlineStore",

    initialize: function(container, application) {
      registerOnlineStoreIntoContainer(container, optionsForOnlineStore);
      injectOnlineStoreIntoApplication(container, application);
    }
  });
});

/**
 * FIXTURES
 */
function resetFixtures() {
  App.Order.FIXTURES = [{
    id: 1,
    customer: 1,
    total: 10.0,
    createdAt: "2013-10-11 12:13:14",
    environment: "offline",
    cart: 1,
    order_items: [1]
  }];

  App.OrderItem.FIXTURES = [{
    id: 1,
    order: 1,
    name: "Ibanez RGS",
    quantity: 1,
    price: 10,
    inventory_entry_id: 1,
    inventory_item: 1
  }];

  App.Cart.FIXTURES = [{
    id: 1, total: 10.0, customer: 1, cart_items: [1, 2]
  }];

  App.CartItem.FIXTURES = [{
    id: 1, price: 10, inventory_entry_id: 1, inventory_item: 1
  }];

  App.InventoryItem.FIXTURES = [{
    id: 1,
    name: "Ibanez",
    description: "Super guitar",
    price: 10.0,
    entry_for_sale_id: 2,
    on_sale: true
  }, {
    id: 2,
    name: "Fender",
    description: "Fender 1",
    price: 100.0,
    entry_for_sale_id: 2,
    on_sale: true
  }, {
    id: 4,
    name: "Fender",
    description: "Fender 3",
    price: 100.0,
    entry_for_sale_id: 2,
    on_sale: true
  }];

  App.StoreReport.FIXTURES = [{
    id: "today_offline", period: "today", environment: "offline", revenue: "3000.0"
  }];

  App.Customer.FIXTURES = [{
    id: 1,
    firstName: "John",
    lastName:  "Rambo",
    email:     "rambo@gmail.com",
    socialSecurityNumber: "87738843403"
  }]
}

resetFixtures();
