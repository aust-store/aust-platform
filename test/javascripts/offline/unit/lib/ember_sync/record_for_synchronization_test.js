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

      /**
       * TODO - why are we passing this around instead of the model?
       */
      jobRecord = Ember.Object.create({
        id:              jobRecordModel.get('id'),
        jobRecordType:   jobRecordModel.get('jobRecordType'),
        jobRecordId:     jobRecordModel.get('jobRecordId'),
        pendingCreation: jobRecordModel.get('pendingCreation')
      });

      subject = EmberSync.RecordForSynchronization.create({
        offlineStore:    offlineStore,
        onlineStore:     onlineStore,
        offlineRecord:   cart,
        jobRecord:       jobRecord
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
  var result;
  stop();

  Em.run(function() {
    subject = EmberSync.RecordForSynchronization.create({
      offlineStore:    offlineStore,
      onlineStore:     onlineStore,
      offlineRecord:   cart,
      jobRecord:       jobRecord
    });

    result = subject.createRecordInStore();

    equal(result.id, cart.id, "Record has same id");
    equal(result.get('total'), "10", "Record has correct total");
    equal(result.get('isNew'), true, "Record isNew");
    equal(result.get('isDirty'), true, "Record isDirty");
    start();
  });
});

test("#createRecordInStore pushes record when pendingCreation is false", function() {
  var result;
  stop();

  Em.run(function() {
    jobRecord.set("pendingCreation", false);

    subject = EmberSync.RecordForSynchronization.create({
      offlineStore:    offlineStore,
      onlineStore:     onlineStore,
      offlineRecord:   offlineStore.createRecord('cart', { total: "10" }),
      jobRecord:       jobRecord
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
  var result;
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

test("#setRelationships sets the belongsTo relationships", function() {
  var onlineCart, customer;
  stop();

  Em.run(function() {
    customer = offlineStore.createRecord('customer', {
      firstName: "John", lastName: "Rambo"
    });
    cart.set('customer', customer);

    equal(cart.get('customer.firstName'), "John", "Customer is set into cart");

    onlineCart = onlineStore.createRecord('cart', { total: "10" });
    ok(!onlineCart.get('customer'), "Newly generated cart has no customer");

    onlineCart = subject.setRelationships(onlineCart);
    var customerId = customer.get('id');

    ok(onlineCart.get('customer'), "Cart has now a customer");
    equal(onlineCart.get("customer.id"), customerId, "Customer has correct id");

    start();
  });
});

test("#setRelationships sets the hasMany relationships", function() {
  var cartItem;
  stop();

  Em.run(function() {
    cartItem = offlineStore.createRecord('cartItem', {
      price: 10,
      inventoryEntryId: 2
    });
    var originalCartItemId = cartItem.get('id');
    cart.get('cartItems').pushObject(cartItem);

    equal(cart.get('cartItems').objectAt(0).get('price'), 10, "CartItem has price");

    cart = onlineStore.createRecord('cart', { total: "10" });
    ok(!cart.get('cartItems.length'), "Newly generated cart has no cart items");

    cart = subject.setRelationships(cart);
    var cartItems = cart.get('cartItems'),
        cartItem  = cartItems.objectAt(0);

    ok(cartItems.get('length'), "Cart has now an item");
    equal(cartItem.get("id"), originalCartItemId, "Item has correct id");
    equal(cartItem.get("price"), 10, "Item has correct price");

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
