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
        priceForInstallments: 11.0,
        inventoryEntryId: 1,
      });

      cartItem2 = store.createRecord('cartItem', {
        price: 10.0,
        priceForInstallments: 11.0,
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
  ok(!cart.isValid(), "cart is invalid without cart items");

  cart.get('cartItems').pushObject(cartItem);
  ok(cart.isValid(), "cart is valid with items");

  cart.set('customer', customer);
  ok(cart.isValid(), "cart is valid after a customer is added");
});

test("#subtotal", function() {
  Em.run(function() {
    equal(cart.get('subtotal'), 0.0, "subtotal is 0 without items");

    cart.get('cartItems').pushObject(cartItem);
    equal(cart.get('subtotal'), 10.0, "subtotal is 10 with 1 item");
    cart.get('cartItems').pushObject(cartItem2);
    equal(cart.get('subtotal'), 20.0, "subtotal is 20 with 2 items");
  });
});

test("#subtotalForInstallments", function() {
  Em.run(function() {
    equal(cart.get('subtotalForInstallments'), 0.0, "subtotalForInstallments is 0 without items");

    cart.get('cartItems').pushObject(cartItem);
    equal(cart.get('subtotalForInstallments'), 11.0, "subtotalForInstallments is 11 with 1 item");
    cart.get('cartItems').pushObject(cartItem2);
    equal(cart.get('subtotalForInstallments'), 22.0, "subtotalForInstallments is 22 with 2 items");
  });
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
