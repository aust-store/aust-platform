//= require offline_test_helper

var contract;

module("Contracts/Models/Cart", {
  setup: function() {
    resetFixtures();
    contract = new EmberTesting.modelContract({
      model: App.Cart,
      root: "cart",
      contractUrl: "/pos/api/v1/resources?model=cart",
      underscoredAttributes: true
    });
  }
});

asyncTest("obeys attributes contract", function() {
  contract.assertAttributes({
    except: ['paymentType']
  });
});

asyncTest("obeys relashionships contract", function() {
  contract.assertAssociations();
});

asyncTest("it has valid fixtures", function() {
  contract.assertFixtures();
});

module("Contracts/Models/Order", {
  setup: function() {
    resetFixtures();
    contract = new EmberTesting.modelContract({
      model: App.Order,
      root: "order",
      contractUrl: "/pos/api/v1/resources?model=order",
      underscoredAttributes: true
    });
  }
});

asyncTest("obeys attributes contract", function() {
  contract.assertAttributes();
});

asyncTest("obeys relashionships contract", function() {
  contract.assertAssociations({
    except: ["cart"]
  });
});

asyncTest("it has valid fixtures", function() {
  contract.assertFixtures();
});

module("Contracts/Models/InventoryItem", {
  setup: function() {
    resetFixtures();
    contract = new EmberTesting.modelContract({
      model: App.InventoryItem,
      root: "inventory_item",
      contractUrl: "/pos/api/v1/resources?model=inventory_item",
      underscoredAttributes: true
    });
  }
});

asyncTest("obeys attributes contract", function() {
  contract.assertAttributes();
});

asyncTest("obeys relashionships contract", function() {
  contract.assertAssociations({
    except: ["cart"]
  });
});

asyncTest("it has valid fixtures", function() {
  contract.assertFixtures();
});

module("Contracts/Models/OrderItem", {
  setup: function() {
    resetFixtures();
    contract = new EmberTesting.modelContract({
      model: App.OrderItem,
      root: "order_item",
      contractUrl: "/pos/api/v1/resources?model=order_item",
      underscoredAttributes: true
    });
  }
});

asyncTest("obeys attributes contract", function() {
  contract.assertAttributes();
});

asyncTest("obeys relashionships contract", function() {
  contract.assertAssociations();
});

asyncTest("it has valid fixtures", function() {
  contract.assertFixtures();
});
