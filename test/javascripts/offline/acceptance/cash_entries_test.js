// require offline_test_helper

var _confirm = window.confirm;

var env;

module("Acceptance/Cash Entries", {
  setup: function() {
    EmberSync.testing = true;
    setupEmberTest();

    env = setupAcceptanceStoreEnv(App);
  },

  teardown: function() {
    EmberSync.testing = false;
    window.confirm = _confirm;
  }
});

test("user creates cash entries", function() {
  var totalCashEntries = App.CashEntry.FIXTURES.length,
      entry1, entry2;

  visit("/cashier");
  andThen(function() {
    var cashierIndex = find("#cashier_index").text().trim(),
        totalOrder   = find(".cashier .balance .total_order .amount").text().trim(),
        cashEntries  = find(".cashier .balance .cash_entries .amount").text().trim(),
        cashBalance  = find(".cashier .balance .cash_balance .amount").text().trim();

    ok(cashierIndex.match(/R\$ 100,00/), "original $100 is there");
    ok(!cashierIndex.match(/R\$ 111,00/), "$111 is not there");

    equal(totalOrder, "R$ 10,00",  "Balance: total in order");
    equal(cashEntries, "R$ 100,00",  "Balance: cash entries");
    equal(cashBalance, "R$ 110,00", "Balance: order + cash");
  });

  /**
   * Register a new addiction
   */
  visit("/cashier/new");

  fillIn("[name='cash_entry_amount']", "111");
  fillIn("[name='cash_entry_description']", "start of the day");

  click(".js_submit_cash_entry");

  andThen(function() {
    Em.run.later(function() {
      EmberSync.Queue.create({
        offlineStore: env.offlineStore,
        onlineStore:  env.onlineStore
      }).process();

      Em.run.later(function() {
        var lastEntry = App.CashEntry.FIXTURES.slice(-1)[0];

        entry1 = lastEntry;

        equal(App.CashEntry.FIXTURES.length, totalCashEntries+1, "Entry saved online");
        equal(lastEntry.amount, "111", "Correct amount");
        equal(lastEntry.description, "start of the day", "Correct description");
      }, 110);
    }, 30);
  });

  visit("/cashier");
  andThen(function() {
    var cashierIndex = find("#cashier_index").text().trim();
        totalOrder   = find(".cashier .balance .total_order .amount").text().trim(),
        cashEntries  = find(".cashier .balance .cash_entries .amount").text().trim(),
        cashBalance  = find(".cashier .balance .cash_balance .amount").text().trim();

    ok(cashierIndex.match(/R\$ 100,00/), "original $100 is still there");
    ok(cashierIndex.match(/R\$ 111,00/), "new $111 shows up on index page");

    equal(totalOrder, "R$ 10,00",  "Balance: total in order");
    equal(cashEntries, "R$ 211,00", "Balance: cash entries");
    equal(cashBalance, "R$ 221,00", "Balance: order + cash");
  });

  /**
   * Register a new subtraction
   */
  visit("/cashier/new");

  fillIn("[name='cash_entry_amount']", "50");
  fillIn("[name='cash_entry_description']", "taking money out");
  fillIn("[name='cash_entry_type']", "subtraction");

  click(".js_submit_cash_entry");

  andThen(function() {
    Em.run.later(function() {
      EmberSync.Queue.create({
        offlineStore: env.offlineStore,
        onlineStore:  env.onlineStore
      }).process();

      Em.run.later(function() {
        var lastEntry = App.CashEntry.FIXTURES.slice(-1)[0];

        equal(App.CashEntry.FIXTURES.length, totalCashEntries+2, "Entry saved online");
        equal(lastEntry.amount, "50", "Correct amount");
        equal(lastEntry.description, "taking money out", "Correct description");
      }, 110);
    }, 30);
  });

  visit("/cashier");
  andThen(function() {
    var cashierIndex = find("#cashier_index").text().trim();
        totalOrder   = find(".cashier .balance .total_order .amount").text().trim(),
        cashEntries  = find(".cashier .balance .cash_entries .amount").text().trim(),
        cashBalance  = find(".cashier .balance .cash_balance .amount").text().trim();

    ok(cashierIndex.match(/R\$ 100,00/), "original $100 is still there");
    ok(cashierIndex.match(/R\$ 111,00/), "new $111 shows up on index page");
    ok(cashierIndex.match(/R\$ 50,00/), "new $50 shows up on index page");

    equal(totalOrder, "R$ 10,00",  "Balance: total in order");
    equal(cashEntries, "R$ 161,00", "Balance: cash entries");
    equal(cashBalance, "R$ 171,00", "Balance: order + cash");
  });

  andThen(function() {
    Em.run.later(function() {
      env.offlineStore.find('cashEntry', entry1.id).then(function(entry) {
        env.offlineStore.unloadRecord(entry);
        env.offlineStore.find('cashEntry', entry1.id).then(function(entry) {
          /**
           * Weird bug where, after adding a record, its `createdAt` becomes
           * null in indexedDB.
           */
          ok(entry.get('createdAt'), "First entry date became null in indexedDB");
        });
      });
    }, 1000);
  });
});
