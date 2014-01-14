// require offline_test_helper

var store,
    cart, customer, cartItem;

module("Models/Cart", {
  setup: function() {
    Ember.run(function() {
      setupEmberTest();

      store = EmberTesting.getStore(App);
      cart = store.createRecord('cart');

      cartItem = store.createRecord('cartItem', {
        price: 10.0,
        inventoryEntryId: 1,
      });

      customer = store.createRecord('customer', {
        firstName: "John",
        lastName: "Rambo",
        email: "rambowisky@gmail.com"
      });
    });
  }
});

test("#isValid", function() {
  ok(!cart.isValid(), "cart is invalid without customer, items and other data");

  cart.get('cartItems').pushObject(cartItem);
  ok(!cart.isValid(), "cart is invalid after item is added is set");

  cart.set('customer', customer);
  ok(cart.isValid(), "cart is valid after all data is defined");
});

test("#save doesn't exclude relationships from the store", function() {
  stop();

  Em.run(function() {
    cart.save().then(function(cart) {
      equal(cart.get('cartItems.length'), 0, "cart has no items initialy");

      cart.get('cartItems').pushObject(cartItem);
      cart.set('customer', customer);

      return Ember.RSVP.resolve(cart);
    }).then(function(cart) {
      equal(cart.get('cartItems.length'), 1, "cart has one item once saved");
      cart.save().then(function(savedCart) {
        equal(savedCart.get('cartItems.length'), 1, "cart continues having one item after being saved again");
        start();
      });
    });
  });
});
