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
    var _this = this;

    return records.filter(function(record) {
      for(var queryKey in query) {
        var value = query[queryKey];

        /**
         * So we can do findQuery with {created_at: "today"}
         */
        queryKey = queryKey.camelize();

        if (queryKey == "search") {
          for(var recordKey in record) {
            if (record[recordKey] === value) {
              return true;
            }
          }
        }
        /**
         * Tries matching dates just like the server would. E.g.
         *
         *     store.findQuery('person', {createdAt: "yesterday"})
         *
         * It will returns only records that match the previous day (yesterday).
         */
        else if (queryKey == "createdAt" || queryKey == "updatedAt") {
          var targetDate = new Date();

          if (value === "today") {
            if (_this.isDateMatch(record[queryKey], targetDate)) {
              return true;
            }
          } else if (value === "yesterday") {
            targetDate.setDate(targetDate.getDate() - 1);
            if (_this.isDateMatch(record[queryKey], targetDate)) {
              return true;
            }
          } else if (match = value.match(/([0-9]{1,}) days ago/i)) {
            targetDate.setDate(targetDate.getDate() - match[1]);
            if (_this.isDateMatch(record[queryKey], targetDate)) {
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
  },

  /**
   * Matches two dates by day.
   */
  isDateMatch: function(rawDateValue, targetDate) {
    var date   = (new Date(Date.parse(rawDateValue))),
        year   = targetDate.getFullYear(),
        month  = targetDate.getMonth(),
        day    = targetDate.getDate(),
        hour   = targetDate.getHours(),
        minute = targetDate.getMinutes();

      if (date.getFullYear() == year &&
          date.getMonth()    == month &&
          date.getDate()     == day) {
        return true;
      }
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
    createdAt: new Date,
    environment: "offline",
    paymentType: "cash",
    cart: 1,
    order_items: [1]
  }];

  App.OrderItem.FIXTURES = [{
    id: 1,
    order: 1,
    name: "Ibanez RGS",
    quantity: 1,
    price: 10,
    price_for_installments: 102.0,
    inventory_entry_id: 1,
    inventory_item: 1,
  }];

  App.Cart.FIXTURES = [{
    id: 1, total: 10.0, customer: 1, cart_items: [1, 2]
  }];

  App.CartItem.FIXTURES = [{
    id: 1, price: 10, inventory_entry_id: 1, inventory_item: 1,
    price_for_installments: 102.0,
  }];

  App.InventoryItem.FIXTURES = [{
    id: 1,
    name: "Ibanez",
    description: "Super guitar",
    price: 11.0,
    priceForInstallments: 102.0,
    entryForSaleId: 2,
    onSale: true,
    barcode: 123,
    referenceNumber: 23,
  }, {
    id: 2,
    name: "Fender",
    description: "Fender 1",
    price: 100.0,
    priceForInstallments: 103.0,
    entryForSaleId: 2,
    onSale: true,
    barcode: 1234,
    referenceNumber: 234,
  }, {
    id: 4,
    name: "Fender",
    description: "Fender 3",
    price: 100.0,
    priceForInstallments: 105.0,
    entryForSaleId: 2,
    onSale: true,
    barcode: 12345,
    referenceNumber: 2345,
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

  App.CashEntry.FIXTURES = [{
    id: 1,
    entryType: "addition",
    amount:    100,
    description: "First entry",
    createdAt: (new Date).toISOString()
  }]
}

resetFixtures();
