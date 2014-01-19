//= require_self
//= require_tree ./offline

QUnit.pending = function() {
  QUnit.test(arguments[0] + ' (SKIPPED)', function() {
    var li = document.getElementById(QUnit.config.current.id);
    QUnit.done(function() {
      li.style.background = '#FFFF99';
    });
    ok(true);
  });
};
pending = QUnit.pending;

function cl(str) { console.log(str); }

var assertItemDoesntExistOffline = function(type, id) {
  var assertMessage = "No item exists offline for id "+id,
      queryFunction = (!!parseInt(id) ? 'find' : 'findQuery');

  return store[queryFunction](type, id).then(function(item) {
    console.error("Record for "+type+" should be in the offline store");
    ok(false, assertMessage);
    return Ember.RSVP.resolve();
  }, function() {
    ok(true, assertMessage);

    return Ember.RSVP.resolve();
  });
}

var assertItemExistsOffline = function(type, id) {
  var assertMessage = ""+type+" record was found for id "+id,
      queryFunction = (!!parseInt(id) ? 'find' : 'findQuery');

  return store[queryFunction](type, id).then(function(item) {
    ok(true, assertMessage);
    return Ember.RSVP.resolve();
  }, function() {
    ok(false, assertMessage);
    return Ember.RSVP.resolve();
  });
}
