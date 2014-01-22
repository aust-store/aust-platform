//= require offline_test_helper

var env = {}, emberSync, subject,
    offlineStore, mock, onlineResults, jobRecord,
    cart,
    onlineStore,
    container;

var Cart     = App.Cart,
    CartItem = App.CartItem,
    Customer = App.Customer;

module("Unit/Lib/EmberSync/Job", {
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
      var jobRecordModel = offlineStore.createRecord('emberSyncQueueModel', {
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

      subject = EmberSync.Job.create({
        offlineStore: offlineStore,
        onlineStore:  onlineStore,
        jobRecord:    jobRecord
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

test("#setBelongsToRelationships sets the record relationships", function() {
  var customer;
  stop();

  Em.run(function() {
    customer = offlineStore.createRecord('customer', {
      firstName: "John", lastName: "Rambo"
    });
    cart.set('customer', customer);

    equal(cart.get('customer.firstName'), "John", "Customer is set into cart");

    cart = onlineStore.createRecord('cart', { total: "10" });
    ok(!cart.get('customer'), "Newly generated cart has no customer");

    subject.setBelongsToRelationships(cart).then(function(cart) {
      var customerId = customer.get('id');

      ok(cart.get('customer'), "Cart has now a customer");
      equal(cart.get("customer.id"), customerId, "Customer has correct id");

      start();
    });
  });
});

test("#setHasManyRelationships sets the record relationships", function() {
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

    subject.setHasManyRelationships(cart).then(function(cart) {
      var cartItems = cart.get('cartItems'),
          cartItem  = cartItems.objectAt(0);

      ok(cartItems.get('length'), "Cart has now an item");
      equal(cartItem.get("id"), originalCartItemId, "Item has correct id");
      equal(cartItem.get("price"), 10, "Item has correct price");

      start();
    });
  });
});
