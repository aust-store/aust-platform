CustomFixtureAdapter = DS.FixtureAdapter.extend({
  /**
   * Used for querying the Fixtures with this.store.find(...)
   */
  queryFixtures: function(records, query, type) {
    return records.filter(function(record) {
      for(var queryKey in query) {
        var value = query[queryKey];

        if (queryKey == "search") {
          for(var recordKey in record) {
            if (record[recordKey] === value) {
              return true;
            }
          }
        }

        if (!query.hasOwnProperty(queryKey)) {
          continue;
        }

        if (record[queryKey] !== value) {
          return false;
        }
      }
      return true;
    });
  }
});

DS.JSONSerializer.reopen({
  serializeHasMany : function(record, json, relationship) {
    var key = relationship.key;

    var relationshipType = DS.RelationshipChange.determineRelationshipType(
      record.constructor, relationship);

    /**
     * Hack to allow FixtureAdapter to not lose hasMany relationships
     */
    if (relationshipType === 'manyToNone'
        || relationshipType === 'manyToMany'
        || relationshipType === 'manyToOne') {
        json[key] = Ember.get(record, key).mapBy('id');
        // TODO support for polymorphic manyToNone and manyToMany
        // relationships
    }
  }
});
App.ApplicationAdapter = CustomFixtureAdapter;
App.ApplicationSerializer = DS.RESTSerializer.extend();

function resetFixtures() {
  App.Order.FIXTURES = [{
    id: 1,
    customer: 1,
    total: 10.0,
    createdAt: "2013-10-11 12:13:14",
    environment: "offline",
    cart: 1,
    order_items: [1]
  }];

  App.OrderItem.FIXTURES = [{
    id: 1,
    order: 1,
    name: "Ibanez RGS",
    quantity: 1,
    price: 10,
    inventory_entry_id: 1,
    inventory_item: 1
  }];

  App.Cart.FIXTURES = [{
    id: 1, total: 10.0, customer: 1, cart_items: [1, 2]
  }];

  App.CartItem.FIXTURES = [{
    id: 1, price: 10, inventory_entry_id: 1, inventory_item: 1
  }];

  App.InventoryItem.FIXTURES = [{
    id: 1,
    name: "Ibanez",
    description: "Super guitar",
    price: 10.0,
    entry_for_sale_id: 2,
    on_sale: true
  }];

  App.StoreReport.FIXTURES = [{
    id: "today_offline", period: "today", environment: "offline", revenue: "3000.0"
  }];

  App.Customer.FIXTURES = [{
    id: 1,
    firstName: "John",
    lastName:  "Rambo",
    email:     "rambo@gmail.com",
    socialSecurityNumber: "87738843403"
  }]
}

resetFixtures();
