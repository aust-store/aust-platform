// require offline_test_helper

var store,
    cart, customer, cartItem;

module("Models/CashEntry", {
  setup: function() {
    Ember.run(function() {
      setupEmberTest();

      store = EmberTesting.getStore(App);
      subject = store.createRecord('cashEntry');
    });
  }
});

test("#isValid", function() {
  ok(!subject.isValid(), "invalid without needed data");

  Em.run(function() {
    subject.set('amount', 20.0);
    subject.set('description', "my description");
    ok(subject.isValid(), "valid with needed information");

    subject.set('amount', null);
    subject.set('description', "my description");
    ok(!subject.isValid(), "returns false if no amount");

    subject.set('amount', 20.0);
    subject.set('description', null);
    ok(!subject.isValid(), "returns false if no description");
    subject.set('description', "my description");
  });
});
