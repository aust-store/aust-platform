// require offline_test_helper

var store, model;

module("Models/Customer", {
  setup: function() {
    setupEmberTest();

    store = EmberTesting.getStore(App);
  }
});

test("#isValid", function() {
  Ember.run(function() {
    model = store.createRecord('customer', {
      firstName: "John",
      lastName: "Rambo",
      email: "rambowisky@gmail.com",
      socialSecurityNumber: "1"
    });

    ok(model.get('isValid'), "Customer is valid with all needed fields");

    /**
     * Required fields
     */
    model.set('firstName', '');
    ok(!model.get('isValid'), "model is invalid without a first name");
    model.set('firstName', 'John');

    model.set('lastName', '');
    ok(!model.get('isValid'), "model is invalid without a last name");
    model.set('lastName', 'Rambo');

    model.set('socialSecurityNumber', '');
    ok(!model.get('isValid'), "model is invalid without a social security number");
    model.set('socialSecurityNumber', '123');

    /**
     * Fields not required
     */
    model.set('email', '');
    ok(model.get('isValid'), "model is valid without an email");
    model.set('email', 'rambo@gmail.com');
  });
});
