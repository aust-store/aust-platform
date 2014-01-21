//= require offline_test_helper

var subject,
    offlineStore, onlineStore;

module("Unit/Lib/EmberSync/Queue", {
  setup: function() {
    stop();

    Em.run(function() {
      App.Cart = DS.Model.extend({
        total: DS.attr('string')
      });

      env = setupOfflineOnlineStore({
        cart: App.Cart,
        emberSyncQueueModel: App.EmberSyncQueueModel
      });
      onlineStore  = env.onlineStore;
      offlineStore = env.store;

      subject = EmberSync.Queue.create({
        offlineStore: offlineStore,
        onlineStore:  onlineStore
      });

      start();
    });
  }
});

test("#removeJobFromQueueArray removes the first item from the queue", function() {
  var cart1, cart2, result;
  stop();

  Em.run(function() {
    cart1 = offlineStore.createRecord('cart');
    cart2 = offlineStore.createRecord('cart');
    cart3 = offlineStore.createRecord('cart');

    subject.set('pendingJobs', Ember.A([cart2, cart1, cart3]));
    subject.removeJobFromQueueArray(cart2);
    result = subject.get('pendingJobs');

    deepEqual(result, [cart1, cart3], "removes first item from the queue");
    start();
  });
});
