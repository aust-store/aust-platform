//= require offline_test_helper

var env = {}, searchOnline, store, mock, onlineResults,
    onlineStore,
    container;

module("Integration/Lib/SearchOnline", {
  setup: function() {
    mock = null;
    setupEmberTest();

    stop();
    env = setupOfflineOnlineStore({ inventoryItem: App.InventoryItem });
    store = env.store;
    onlineStore = env.onlineStore;
    searchOnline = App.SearchOnline.create({ container: env });
    start();
  }
});

test("setup is working", function() {
  stop();
  Em.run(function() {
    onlineStore.find('inventoryItem', 1).then(function(item) {
      equal(item.get('name'), "Ibanez", "Loads data from the online store");
      start();
    });
  });
});

var assertItemDoesntExistOffline = function(type, id) {
  return store.find(type, 1).then(function() {
    ok(false, "Items were found");
  }, function() {
    ok(true, "No item exists offline");

    return Ember.RSVP.resolve();
  });
}

test("#find searches online and add results to the offline database", function() {
  expect(5);
  stop();

  Em.run(function() {
    store.find('inventoryItem', 1).then(function() {
      ok(false, "Items were found");
    }, function() {
      ok(true, "No item exists offline");

      return searchOnline.find('inventoryItem', 1);
    }).then(function(item) {
      equal(item.get('name'), "Ibanez", "Loads data from the online store");

      Em.run.later(function() {
        store.find('inventoryItem', 1).then(function(item) {

          ok(true, "Item was added to the offline store");
          equal(item.get('id'),   1,        "New offline item has a correct id");
          equal(item.get('name'), "Ibanez", "New offline item has a correct name");
          start();
        });
      }, 3);
    });
  });
});

pending("#find searches offline and online simultaneous", function() {
  expect(5);
  stop();

  Em.run(function() {
    store.find('inventoryItem', 1).then(function() {
      ok(false, "Items were found");
    }, function() {
      ok(true, "No item exists offline");

      return searchOnline.find('inventoryItem', 1);
    }).then(function(item) {
      equal(item.get('name'), "Ibanez", "Loads data from the online store");

      Em.run.later(function() {
        store.find('inventoryItem', 1).then(function(item) {

          ok(true, "Item was added to the offline store");
          equal(item.get('id'),   1,        "New offline item has a correct id");
          equal(item.get('name'), "Ibanez", "New offline item has a correct name");
          start();
        });
      }, 3);
    });
  });
});
