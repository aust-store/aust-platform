//= require offline_test_helper

var env = {}, emberSync, emberSyncQueue,
    store, mock, onlineResults,
    onlineStore,
    container;

module("Integration/Lib/EmberSync/Queue", {
  setup: function() {
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
    store = env.store;
    onlineStore = env.onlineStore;
    emberSync = App.EmberSync.create({ container: env });
    emberSyncQueue = EmberSync.Queue.create({ container: env });
    start();
  },

  tearDown: function() {
    EmberSync.testing = true;
  }
});

test("#process pushes all jobs to the online store", function() {
  var onlineTotalRecords = App.Cart.FIXTURES.length;
  stop();

  Em.run(function() {
    var record = emberSync.createRecord('cart', {
      total: "10",
    });
    var recordId = record.get('id');

    var promise = store.findQuery('emberSyncQueueModel', {jobRecordId: recordId});

    promise.then(function(found) {
      ok(false, "Test begins with no jobs");
      return record.emberSync.save();
    }, function() {
      ok(true, "Test begins with no jobs");
      return record.emberSync.save();
    }).then(function() {
      return new Ember.RSVP.Promise(function(resolve, reject) {
        Ember.run.later(function() {
          emberSyncQueue.process();
        }, 20);

        Ember.run.later(function() {
          resolve();
        }, 100);
      });
    }).then(function() {
      return onlineStore.find('cart', recordId);
    }).then(function(cart) {
      equal(cart.get('total'), "10", "Cart value is correct");
      equal(App.Cart.FIXTURES.length, onlineTotalRecords+1, "Record goes online");

      return Ember.RSVP.resolve();
    }, function() {
      ok(false, "Cart is pushed to the online store");
      return Ember.RSVP.resolve();
    }).then(function() {
      var findJob = store.findQuery('emberSyncQueueModel', {jobRecordId: recordId});

      findJob.then(function() {
        ok(false, "Processed job is deleted");
        start();
      }, function() {
        ok(true, "Processed job is deleted");
        start();
      });
    });
  });
});
