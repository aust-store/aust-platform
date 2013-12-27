// require offline_test_helper

var store, cart;

module("Models/Cart", {
  setup: function() {
    Ember.run(function() {
      setupEmberTest();

      store = EmberTesting.getStore(App);
      cart = store.createRecord('cart');
    });
  }
});

test("#isValid", function() {
  var item, customer, cartItem;

  Ember.run(function() {
    cartItem = store.createRecord('cartItem', {
      price: 10.0,
      cart: cart,
      inventoryEntryId: 1,
    });

    customer = store.createRecord('customer', {
      firstName: "John",
      lastName: "Rambo",
      email: "rambowisky@gmail.com"
    });
  });

  ok(!cart.isValid(), "cart is invalid without customer, items and other data");

  cart.get('items').pushObject(cartItem);
  ok(!cart.isValid(), "cart is invalid after item is added is set");

  cart.set('customer', customer);
  ok(cart.isValid(), "cart is valid after all data is defined");
});
