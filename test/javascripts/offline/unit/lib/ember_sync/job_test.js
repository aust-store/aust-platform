//= require offline_test_helper

var env = {}, emberSync, subject,
    offlineStore, mock, onlineResults, jobRecord, jobRecordModel,
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
      jobRecordModel = offlineStore.createRecord('emberSyncQueueModel', {
        jobRecordType: "cart",
        serialized:    cart.serialize({includeId: true}),
        operation:     "create",
        createdAt:     (new Date).toUTCString()
      });

      /**
       * TODO - why are we passing this around instead of the model?
       */
      jobRecord = Ember.Object.create({
        id:            jobRecordModel.get('id'),
        jobRecordType: jobRecordModel.get('jobRecordType'),
        serialized:    jobRecordModel.get('serialized'),
        operation:     jobRecordModel.get('operation')
      });

      subject = EmberSync.Job.create({
        offlineStore:    offlineStore,
        onlineStore:     onlineStore,
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

test("#deletion unloads previous record and recreates it", function() {
  var result;
  stop();

  Em.run(function() {
    jobRecord = Ember.Object.create({
      id:            jobRecordModel.get('id'),
      jobRecordType: jobRecordModel.get('jobRecordType'),
      serialized:    jobRecordModel.get('serialized'),
      operation:     'delete'
    });

    subject = EmberSync.Job.create({
      offlineStore:    offlineStore,
      onlineStore:     onlineStore,
      jobRecord:       jobRecord
    });

    subject.deletion().then(function(deleted) {
      equal(deleted.id, cart.id,   "Record has same id");
      equal(deleted.get('isNew'),   false, "Record is new (so we use POST)");
      equal(deleted.get('isDirty'), true, "Record isDirty");
      equal(deleted.get('currentState.stateName'), "root.deleted.uncommitted", "Record is deleted but uncommitted");

      subject.deletion().then(function(deleted) {
        equal(deleted.id, cart.id,   "Record has same id");
        equal(deleted.get('isNew'),   false, "Record is new (so we use POST)");
        equal(deleted.get('isDirty'), true, "Record isDirty");
        equal(deleted.get('currentState.stateName'), "root.deleted.uncommitted", "Record is deleted but uncommitted");
        start();
      });
    });
  });
});
