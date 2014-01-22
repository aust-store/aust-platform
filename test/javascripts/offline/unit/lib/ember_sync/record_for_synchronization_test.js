//= require offline_test_helper

var env = {}, emberSync, subject,
    offlineStore, mock, onlineResults, jobRecord, jobRecordModel,
    cart,
    onlineStore,
    container;

var Cart     = App.Cart,
    CartItem = App.CartItem,
    Customer = App.Customer;

module("Unit/Lib/EmberSync/RecordForSynchronization", {
  setup: function() {
    Em.run(function() {
      mock = null;
      App.Cart = DS.Model.extend({
        total:     DS.attr('string'),
        cartItems: DS.hasMany('cartItem'),
        customer:  DS.belongsTo('customer'),
      });

      App.Customer = DS.Model.extend({
        name: attr('number'),
        cart: DS.belongsTo('cart'),
      });

      App.CartItem = DS.Model.extend({
        price: attr('number'),
        cart:  DS.belongsTo('cart'),
      });

      setupEmberTest();

      EmberSync.testing = true;
      stop();

      env = setupOfflineOnlineStore({
        cart: App.Cart,
        cartItem: App.CartItem,
        customer: App.Customer,
        emberSyncQueueModel: App.EmberSyncQueueModel
      });

      offlineStore = env.store;
      onlineStore = env.onlineStore;

      /**
       * Sets up the models, queue and jobs
       */
      cart = offlineStore.createRecord('cart', { total: "10" });
      jobRecordModel = offlineStore.createRecord('emberSyncQueueModel', {
        jobRecordType:   "cart",
        jobRecordId:     cart.get('id'),
        pendingCreation: true,
        createdAt:       (new Date).toUTCString()
      });

      jobRecord = Ember.Object.create({
        id:            jobRecordModel.get('id'),
        jobRecordType: jobRecordModel.get('jobRecordType'),
        jobRecordId:   jobRecordModel.get('jobRecordId')
      });

      subject = EmberSync.RecordForSynchronization.create({
        offlineStore:    offlineStore,
        onlineStore:     onlineStore,
        recordType:      "cart",
        recordId:        cart.get('id'),
        jobId:           jobRecordModel.id,
        offlineRecord:   offlineStore.createRecord('cart', { total: "10" }),
        pendingCreation: true,
        createdAt:       (new Date).toUTCString()
      });

      start();
    });
  },

  tearDown: function() {
    EmberSync.testing = true;

    App.Cart     = Cart;
    App.CartItem = CartItem;
    App.Customer = Customer;
  }
});

test("#createRecordInStore creates a new record in store for pendingCreation", function() {
  var result, expected;
  stop();

  Em.run(function() {
    result = subject.createRecordInStore();

    equal(result.id, cart.id, "Record has same id");
    equal(result.get('total'), "10", "Record has correct total");
    equal(result.get('isNew'), true, "Record isNew");
    equal(result.get('isDirty'), true, "Record isDirty");
    start();
  });
});

test("#createRecordInStore pushes record when pendingCreation is false", function() {
  var result, expected;
  stop();

  Em.run(function() {
    subject = EmberSync.RecordForSynchronization.create({
      offlineStore:    offlineStore,
      onlineStore:     onlineStore,
      recordType:      "cart",
      recordId:        cart.get('id'),
      jobId:           jobRecordModel.id,
      offlineRecord:   offlineStore.createRecord('cart', { total: "10" }),
      pendingCreation: false,
      createdAt:       (new Date).toUTCString()
    });

    result = subject.createRecordInStore();

    equal(result.id, cart.id, "Record has same id");
    equal(result.get('total'), "10", "Record has correct total");
    equal(result.get('isNew'), false, "Record is not new (so we use PUT)");
    equal(result.get('isDirty'), false, "Record isDirty");
    start();
  });
});

test("#createRecordInStore unloads previous record and recreates it with pendingCreation true", function() {
  var result, expected;
  stop();

  Em.run(function() {
    subject.createRecordInStore();

    result = subject.createRecordInStore();
    equal(result.id, cart.id,    "Record has same id");
    equal(result.get('total'),   "10", "Record has correct total");
    equal(result.get('isNew'),   true, "Record is new (so we use POST)");
    equal(result.get('isDirty'), true, "Record isDirty");
    start();
  });
});

test("#propertiesToPersist returns only attributes", function() {
  var result, expected;
  stop();

  Em.run(function() {
    expected = {
      id: cart.get('id'),
      total: "10"
    };

    result = subject.propertiesToPersist(cart);

    deepEqual(result, expected, "Properties are correct");
    start();
  });
});
