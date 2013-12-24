//= require offline_test_helper

var contract;

module("Contracts/Models/Cart", {
  setup: function() {
    resetFixtures();
    contract = new EmberTesting.modelContract({
      model: App.Cart,
      root: "cart",
      contractUrl: "/admin/api/v1/resources?model=cart"
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

module("Contracts/Models/Order", {
  setup: function() {
    resetFixtures();
    contract = new EmberTesting.modelContract({
      model: App.Order,
      root: "order",
      contractUrl: "/admin/api/v1/resources?model=order"
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
      contractUrl: "/admin/api/v1/resources?model=inventory_item"
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
