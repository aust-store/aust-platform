//= require offline_test_helper

var env = {}, emberSync, store, mock, onlineResults,
    onlineStore,
    container;

module("Integration/Lib/EmberSync", {
  setup: function() {
    mock = null;
    setupEmberTest();

    stop();
    env = setupOfflineOnlineStore({
      inventoryItem: App.InventoryItem,
      emberSyncQueueModel: App.EmberSyncQueueModel
    });
    store = env.store;
    onlineStore = env.onlineStore;
    emberSync = App.EmberSync.create({ container: env });
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
      return emberSync.find('inventoryItem', 1);
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
      return emberSync.findQuery('inventoryItem', {name: "Fender"});
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

test("#createRecord creates a new record", function() {
  var record, prop;

  Em.run(function() {
    prop = {
      name: "Fender",
      description: "Super guitar",
      price: "123",
      entryForSaleId: "1",
      onSale: true
    };
    record = emberSync.createRecord('inventoryItem', prop);

    equal(record.get('name'), 'Fender', 'name is correct');
    equal(record.get('description'), 'Super guitar', 'description is correct');
    equal(record.get('price'), '123', 'price is correct');
    equal(record.get('entryForSaleId'), '1', 'entryForSaleId is correct');
    equal(record.get('onSale'), true, 'onSale is correct');

    equal(record.emberSync.recordType, 'inventoryItem', 'emberSync.recordType is correct');
    equal(record.emberSync.recordProperties, prop, 'emberSync.recordProperties is correct');
    equal(record.emberSync, emberSync, 'emberSync instance is correct');
    equal(record.emberSync.record, record, 'emberSync.record instance is correct');
  });
});

pending("#save creates a record offline and online", function() {
  var record, offlineSave, generatedId;
  stop();

  Em.run(function() {
    record = emberSync.createRecord('inventoryItem', {
      name: "Fender",
      description: "Super guitar",
      price: "123",
      entryForSaleId: "1",
      onSale: true
    });

    generatedId = record.get('id');
    ok(generatedId, "ID is valid ("+generatedId+")");

    offlineSave = record.emberSync.save();
    offlineSave.then(function(record) {
      ok(true, "Record saved offline");
      equal(record.get('id'),             generatedId,    "id is correct");
      equal(record.get('name'),           "Fender",       "name is correct");
      equal(record.get('description'),    "Super guitar", "description is correct");
      equal(record.get('price'),          "123",          "price is correct");
      equal(record.get('entryForSaleId'), "1",            "entryForSaleId is correct");
      equal(record.get('onSale'),         true,           "onSale is correct");

      Em.run.later(function() {
        var record = App.InventoryItem.FIXTURES.slice(-1)[0];

        ok(true, "Record saved online");
        equal(record.id,             generatedId,    "id is correct");
        equal(record.name,           "Fender",       "name is correct");
        equal(record.description,    "Super guitar", "description is correct");
        equal(record.price,          "123",          "price is correct");
        equal(record.entryForSaleId, "1",            "entryForSaleId is correct");
        equal(record.onSale,         true,           "onSale is correct");
        start();
      }, 100);

    }, function() {
      ok(false, "Record saved offline");
      start();
    });
  });
});

pending("#save works when no properties were given", function() {
  var record, offlineSave, generatedId;
  stop();

  Em.run(function() {
    record = emberSync.createRecord('inventoryItem');

    generatedId = record.get('id');
    ok(generatedId, "ID is valid ("+generatedId+")");

    offlineSave = record.emberSync.save();
    offlineSave.then(function(record) {
      ok(true, "Record saved offline");
      equal(record.get('id'), generatedId, "id is correct");

      Em.run.later(function() {
        var record = App.InventoryItem.FIXTURES.slice(-1)[0];
        equal(record.id, generatedId, "id is correct");
        start();
      }, 100);

    }, function() {
      ok(false, "Record saved offline");
      start();
    });
  });
});

test("#save returns the same DS.Model instance that was created", function() {
  stop();

  Em.run(function() {
    var record = emberSync.createRecord('inventoryItem', {
      name: "Fender",
      description: "Super guitar",
      price: "123",
      entryForSaleId: "1",
      onSale: true
    });

    record.emberSync.save().then(function(item) {
      ok(item.emberSync, "Returned record has emberSync method");
      equal(item.emberSync.recordType, "inventoryItem", "Returned record has correct type");
      start();
    });
  });
});

test("#save creates a record offline and enqueues online synchronization", function() {
  var oldRecord, newRecord, offlineSave, generatedId;
  stop();

  Em.run(function() {
    var record = emberSync.createRecord('inventoryItem', {
      name: "Old Fender 1",
      description: "Super guitar",
      price: "123",
      entryForSaleId: "1",
      onSale: true
    });

    return record.emberSync.save();
  }).then(function(oldRecord) {
    oldRecord.set('name', 'Old Fender 2');
    return oldRecord.emberSync.save();
  }).then(function(oldRecord) {
    ok(oldRecord.get('id'), "Record has a valid ID");

    newRecord = emberSync.createRecord('inventoryItem', {
      name: "Fender",
      description: "Super guitar",
      price: "123",
      entryForSaleId: "1",
      onSale: true
    });

    newRecordId = newRecord.get('id');
    ok(newRecordId, "ID is valid ("+newRecordId+")");

    offlineSave = newRecord.emberSync.save();
    offlineSave.then(function(newRecord) {
      ok(true, "Record saved offline");
      equal(newRecord.get('id'),             newRecordId,    "id is correct ("+newRecordId+")");
      equal(newRecord.get('name'),           "Fender",       "name is correct");
      equal(newRecord.get('description'),    "Super guitar", "description is correct");
      equal(newRecord.get('price'),          "123",          "price is correct");
      equal(newRecord.get('entryForSaleId'), "1",            "entryForSaleId is correct");
      equal(newRecord.get('onSale'),         true,           "onSale is correct");

      Ember.run.later(function() {
        var jobs = store.find('emberSyncQueueModel');

        jobs.then(function(jobs) {
          equal(jobs.get('length'), 3, "One synchronization job is created");

          var creationJob  = jobs.objectAt(0),
              updateJob    = jobs.objectAt(1),
              creationJob2 = jobs.objectAt(2),

              job1Date = Date.parse(creationJob.get('createdAt')),
              job2Date = Date.parse(updateJob.get('createdAt')),
              job3Date = Date.parse(creationJob2.get('createdAt'));

          /**
           * First job to create the record
           */
          equal(creationJob.get('id'), "1", "creation job's id is correct");
          equal(creationJob.get('jobRecordId'),     oldRecord.id, "creation job's record id is correct");
          equal(creationJob.get('jobRecordType'),   'inventoryItem', "creation job's record type is correct");
          equal(creationJob.get('pendingCreation'), true, "creation job's pending creation is true");
          ok(creationJob.get('createdAt'), "creation job's date is correct");

          /**
           * Second job to update the record
           */
          equal(updateJob.get('id'), 2, "update job's id is correct");
          equal(updateJob.get('jobRecordId'),     oldRecord.id, "update job's record id is correct");
          equal(updateJob.get('jobRecordType'),   'inventoryItem', "update job's record type is correct");
          equal(updateJob.get('pendingCreation'), false, "update job's pending creation is false");
          ok(updateJob.get('createdAt'), "update job's has a date");

          /**
           * Third job to create a new record
           */
          equal(creationJob2.get('id'), 3, "creation job's id is correct");
          equal(creationJob2.get('jobRecordId'),     newRecord.id, "creation job's new record id is correct");
          equal(creationJob2.get('jobRecordType'),   'inventoryItem', "creation job's new record type is correct");
          equal(creationJob2.get('pendingCreation'), true, "create job's pending creation is false");
          ok(creationJob2.get('createdAt'), "creation job 2's date is correct");
          start();
        });
      }, 80);

    }, function() {
      ok(false, "Record saved offline");
      start();
    });
  });
});