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
  var assertMessage = "No item exists offline for id "+id,
      queryFunction = (!!parseInt(id) ? 'find' : 'findQuery');

  return store[queryFunction](type, id).then(function(item) {
    console.error("Record for "+type+" should be in the offline store");
    ok(false, assertMessage);
    return Ember.RSVP.resolve();
  }, function() {
    ok(true, assertMessage);

    return Ember.RSVP.resolve();
  });
}

var assertItemExistsOffline = function(type, id) {
  var assertMessage = ""+type+" record was found for id "+id,
      queryFunction = (!!parseInt(id) ? 'find' : 'findQuery');

  return store[queryFunction](type, id).then(function(item) {
    ok(true, assertMessage);
    return Ember.RSVP.resolve();
  }, function() {
    ok(false, assertMessage);
    return Ember.RSVP.resolve();
  });
}

test("#find searches offline/online simultaneously, syncing online into offline and returning a stream of data", function() {
  expect(5);
  stop();

  Em.run(function() {
    assertItemDoesntExistOffline('inventoryItem', 1).then(function() {
      return searchOnline.find('inventoryItem', 1);
    }).then(function(item) {
      Em.run.later(function() {
        equal(item.get('name'), "Ibanez", "Loads data from the online store");
      }, 70);

      Em.run.later(function() {
        store.find('inventoryItem', 1).then(function(item) {

          ok(true, "Item was added to the offline store");
          equal(item.get('id'),   1,        "New offline item has a correct id");
          equal(item.get('name'), "Ibanez", "New offline item has a correct name");
          start();
        }, function() {
          console.log("Item was not added to the offline store");
          ok(false, "Item was added to the offline store");
        });
      }, 70);
    });
  });
});

test("#findQuery searches offline/online simultaneously, syncing online into offline and returning a stream of data", function() {
  var item, duplicatedItem;

  expect(14);
  stop();

  Em.run(function() {
    assertItemDoesntExistOffline('inventoryItem', {name: "Fender"}).then(function() {
      item = store.createRecord('inventoryItem', {
        id: 3,
        name: "Fender",
        description: "Fender 2",
        price: 200.0,
        entry_for_sale_id: 2,
        on_sale: true
      });

      duplicatedItem = store.createRecord('inventoryItem', {
        id: 4,
        name: "Fender",
        description: "Fender 3 from offline",
        price: 300.0,
        entry_for_sale_id: 2,
        on_sale: true
      });

      return Ember.RSVP.all([item.save(), duplicatedItem.save()]);
    }).then(function(item) {
      return assertItemExistsOffline('inventoryItem', {name: "Fender"});
    }).then(function() {
      return searchOnline.findQuery('inventoryItem', {name: "Fender"});
    }).then(function(items) {
      equal(items.length, 0, "At first, an empty array of results is returned");

      Em.run.later(function() {
        equal(items.get('length'), 2, "Offline record is added asynchronously");
        var firstItem, secondItem;

        firstItem = items.objectAt(0);
        equal(firstItem.get('id'),   3,        "Offline item id is correct");
        equal(firstItem.get('name'), "Fender", "Offline item name is correct");
        equal(firstItem.get('description'), "Fender 2", "Offline item description is correct");
        secondItem = items.objectAt(1);
        equal(secondItem.get('id'),   4,        "Offline item id is correct");
        equal(secondItem.get('name'), "Fender", "Offline item name is correct");
        equal(secondItem.get('description'), "Fender 3 from offline", "Offline item description is correct");
      }, 10);

      Em.run.later(function() {
        var thirdItem;
        equal(items.get('length'), 3, "Second online record is magically added to the result stream asynchronously");

        thirdItem = items.objectAt(2);
        equal(thirdItem.get('id'),   2,        "Online item id is correct");
        equal(thirdItem.get('name'), "Fender", "Online item name is correct");
        equal(thirdItem.get('description'), "Fender 1", "Online item description is correct");
        start();
      }, 180);
    });
  });
});
