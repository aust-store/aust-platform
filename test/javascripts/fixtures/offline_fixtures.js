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

App.ApplicationAdapter = CustomFixtureAdapter;

function resetFixtures() {
  App.Order.FIXTURES = [
    { id: 1, total: 10.0, created_at: "2013-10-11 12:13:14", environment: "offline" }
  ];

  App.Cart.FIXTURES = [
    { id: 1, total: 10.0 }
  ];

  App.InventoryItem.FIXTURES = [
    { id: 1, name: "Ibanez", description: "", price: 10.0, entry_for_sale_id: 2, on_sale: true }
  ];

  App.StoreReport.FIXTURES = [
    { id: "today_offline", period: "today", environment: "offline", revenue: "3000.0" }
  ];
}

resetFixtures();
