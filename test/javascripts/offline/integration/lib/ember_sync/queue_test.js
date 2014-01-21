//= require offline_test_helper

var env = {}, emberSync, emberSyncQueue,
    store, mock, onlineResults,
    onlineStore,
    originalDSModelSave;

var Cart     = App.CartItem,
    CartItem = App.CartItem,
    Customer = App.CartItem;

module("Integration/Lib/EmberSync/Queue", {
  setup: function() {
    mock = null;
    originalDSModelSave = DS.Model.prototype.save;
    console.log(originalDSModelSave);

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

    setupEmberTest();

    EmberSync.testing = true;

    env = setupOfflineOnlineStore({
      cart:     App.Cart,
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

    App.Cart     = Cart;
    App.CartItem = CartItem;
    App.Customer = Customer;
    DS.Model.prototype.save = originalDSModelSave;
  }
});

var assertNoJobsExist = function(recordId) {
  var promise = store.findQuery('emberSyncQueueModel', {jobRecordId: recordId});

  return new Ember.RSVP.Promise(function(resolve, reject) {
    promise.then(function(found) {
      ok(false, "Test begins with no jobs");
      resolve();
    }, function() {
      ok(true, "Test begins with no jobs");
      resolve();
    });
  });
};

test("#process pushes all jobs to the online store", function() {
  var onlineTotalRecords = App.Cart.FIXTURES.length;
  stop();

  Em.run(function() {
    var record = emberSync.createRecord('cart', {
      total: "10",
    });
    var recordId = record.get('id');

    assertNoJobsExist(recordId).then(function() {
      return record.emberSync.save();
    }).then(function() {
      return new Ember.RSVP.Promise(function(resolve, reject) {
        Ember.run.later(function() {
          emberSyncQueue.process();
        }, 5);

        Ember.run.later(function() {
          resolve();
        }, 50);
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

test("#process works for a sequence of related records", function() {
  var cart, cartId, cartItem, itemId,
      onlineTotalCarts     = App.Cart.FIXTURES.length,
      onlineTotalCartItems = App.CartItem.FIXTURES.length;

  stop();

  Em.run(function() {
    cart     = emberSync.createRecord('cart', {total: 98});
    cartItem = emberSync.createRecord('cartItem', {price: 97, inventoryEntryId: 96});
    cartId   = cart.get('id');
    itemId   = cartItem.get('id');

    cart.get('cartItems').pushObject(cartItem);

    var SaveCart = function() {
      return cart.emberSync.save();
    }

    var SaveCartItem = function() {
      return cartItem.emberSync.save();
    }

    var ProcessQueue = function() {
      ok(store.hasRecordForId('cart', cartId), "Cart is still in the store");
      ok(store.hasRecordForId('cartItem', itemId), "Item is still in the store");

      return new Ember.RSVP.Promise(function(resolve, reject) {
        Em.run.later(function() {
          emberSyncQueue.process();
        }, 5);

        Em.run.later(function() {
          resolve();
        }, 50);
      });
    }

    var TestRecordsArePersisted = function() {
      var newOnlineTotalCarts     = App.Cart.FIXTURES.length,
          newOnlineTotalCartItems = App.CartItem.FIXTURES.length,
          lastCart = App.Cart.FIXTURES.slice(-1)[0],
          lastItem = App.CartItem.FIXTURES.slice(-1)[0];

      equal(newOnlineTotalCarts,     onlineTotalCarts+1,     "Cart was pushed");
      equal(newOnlineTotalCartItems, onlineTotalCartItems+1, "Item was pushed");

      equal(lastCart.id,    cart.get('id'), "Created cart has correct id")
      equal(lastCart.total, "98", "Created cart has correct total")
      equal(lastItem.id,    cartItem.get('id'), "Created item has correct id")
      equal(lastItem.price, "97", "Created item has correct total")
      return Ember.RSVP.resolve();
    }

    var TestRecordsIntegrity = function() {
      var lastCart = App.Cart.FIXTURES.slice(-1)[0],
          lastItem = App.CartItem.FIXTURES.slice(-1)[0];

      onlineStore.find('cartItem', lastItem.id).then(function(item) {
        ok(true, "cart item is found online");

        equal(item.get('cart.id'), lastCart.id, "Item belongs to the correct cart");
        equal(item.get('cart.total'), "98", "Item's cart has correct total");
        ok(store.hasRecordForId('cart', cartId), "Cart is still in the store");
        ok(store.hasRecordForId('cartItem', itemId), "Item is still in the store");
        start();
      }, function() {
        ok(false, "cart item is found online");
        start();
      });
    };

    assertNoJobsExist(cartId).then(SaveCart)
                             .then(SaveCartItem)
                             .then(ProcessQueue)
                             .then(TestRecordsArePersisted)
                             .then(TestRecordsIntegrity);
  });
});

test("#process retries processing if synchronization fails", function() {
  var cart, cartId, cartItem, itemId,
      onlineTotalCarts     = App.Cart.FIXTURES.length,
      onlineTotalCartItems = App.CartItem.FIXTURES.length;

  stop();

  Em.run(function() {
    cart     = emberSync.createRecord('cart', {total: 98});
    cartItem = emberSync.createRecord('cartItem', {price: 97, inventoryEntryId: 96});
    cartId   = cart.get('id');
    itemId   = cartItem.get('id');

    cart.get('cartItems').pushObject(cartItem);

    var SaveCart = function() {
      return cart.emberSync.save();
    }

    var SaveCartItem = function() {
      return cartItem.emberSync.save();
    }

    var ProcessQueue = function() {
      ok(store.hasRecordForId('cart', cartId), "Cart is still in the store");
      ok(store.hasRecordForId('cartItem', itemId), "Item is still in the store");

      return new Ember.RSVP.Promise(function(resolve, reject) {
        Em.run.later(function() {
          emberSyncQueue.process();
        }, 5);

        Em.run.later(function() {
          resolve();
        }, 50);
      });
    }

    var TestRecordsArePersisted = function() {
      var newOnlineTotalCarts     = App.Cart.FIXTURES.length,
          newOnlineTotalCartItems = App.CartItem.FIXTURES.length,
          lastCart = App.Cart.FIXTURES.slice(-1)[0],
          lastItem = App.CartItem.FIXTURES.slice(-1)[0];

      equal(newOnlineTotalCarts,     onlineTotalCarts+1,     "Cart was pushed");
      equal(newOnlineTotalCartItems, onlineTotalCartItems+1, "Item was pushed");

      equal(lastCart.id,    cart.get('id'), "Created cart has correct id")
      equal(lastCart.total, "98", "Created cart has correct total")
      equal(lastItem.id,    cartItem.get('id'), "Created item has correct id")
      equal(lastItem.price, "97", "Created item has correct total")
      return Ember.RSVP.resolve();
    }

    var TestRecordsIntegrity = function() {
      var lastCart = App.Cart.FIXTURES.slice(-1)[0],
          lastItem = App.CartItem.FIXTURES.slice(-1)[0];

      onlineStore.find('cartItem', lastItem.id).then(function(item) {
        ok(true, "cart item is found online");

        equal(item.get('cart.id'), lastCart.id, "Item belongs to the correct cart");
        equal(item.get('cart.total'), "98", "Item's cart has correct total");
        ok(store.hasRecordForId('cart', cartId), "Cart is still in the store");
        ok(store.hasRecordForId('cartItem', itemId), "Item is still in the store");
        start();
      }, function() {
        ok(false, "cart item is found online");
        start();
      });
    };

    assertNoJobsExist(cartId).then(SaveCart)
                             .then(SaveCartItem)
                             .then(ProcessQueue)
                             .then(TestRecordsArePersisted)
                             .then(TestRecordsIntegrity);
  });
});
