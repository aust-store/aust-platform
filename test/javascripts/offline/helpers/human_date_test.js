// require offline_test_helper

module("Helpers", {
  setup: function() {
    Ember.run(function() {
      setupEmberTest();
    });
  }
});

test("#humanDate", function() {
  var results = [
    { before: '2013-4-3 0:15:09',              after: '3/4/2013, 00:15' },
    { before: '2013-04-03 00:15:09',           after: '03/04/2013, 00:15' },
    { before: '2014-01-31T00:30:41.000-02:00', after: '31/1/2014, 00:30' },
    { before: (new Date(Date.parse('Fri Jan 31 2014 17:45:16 GMT-0200 (BRST)'))), after: '31/1/2014, 17:45' },
  ]

  for(var entry in results) {
    if (!results.hasOwnProperty(entry)) {
      break;
    }

    var before = results[entry].before,
        after  = results[entry].after;
        console.log(before);
        console.log(after);
    equal(humanDate(before), after, before+" becomes "+after);
  }
});
