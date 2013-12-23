CustomFixtureAdapter = DS.FixtureAdapter.extend({
  /**
   * Used for querying the Fixtures with this.store.find(...)
   */
  queryFixtures: function(records, query, type) {
    return records.filter(function(record) {
      for(var key in query) {
        if (!query.hasOwnProperty(key)) { continue; }
        var value = query[key];
        if (record[key] !== value) { return false; }
      }
      return true;
    });
  }
});

App.ApplicationAdapter = CustomFixtureAdapter;
App.Order.FIXTURES = [
  { id: 1, total: 10.0, created_at: "2013-10-11 12:13:14", environment: "offline" }
];

App.Cart.FIXTURES = [
  { id: 1, total: 10.0 }
];

App.InventoryItem.FIXTURES = [
  { id: 1, name: "Ibanez", description: "", price: 10.0, entry_for_sale_id: 2, on_sale: true }
];
