//= require offline_test_helper

var env = {}, subject, mock;

module("Unit/Lib/EmberOffline", {
  setup: function() {
    stop();
    Em.run(function() {
      mock = null;

      EmberOfflineTesting = true;
      subject = App.EmberOffline.create();
      subject.set('hideBackOnlineMessageDelay', 1);
      subject.set('showBackOnlineMessageDelay', 1);

      start();
    });
  },
  teardown: function() {
    EmberOfflineTesting = false;
  }
});

test("#goOffline defines correct messages and everything", function() {
  stop();

  Em.run(function() {
    subject.goOffline();

    Em.run.later(function() {
      ok(!subject.get('isConnected'), "not connected");
      equal(subject.get('noConnectionMessage'), "Internet fora do ar", "offline message");

      start();
    }, 5);
  });
});

test("#goOnline goes online", function() {
  stop();

  Em.run(function() {
    subject.goOffline();
    subject.goOnline();

    Em.run.later(function() {
      ok(subject.get('isConnected'), "connected");
      ok(!subject.get('noConnectionMessage'), "no offline message");

      start();
    }, 5);
  });
});
