//= require offline/application_manifest
//= require ./fixtures/offline_fixtures
//= require ./emberjs_test_helper
//= require_self

App.rootElement = '#qunit-fixture';
App.setupForTesting();
App.injectTestHelpers();
App.defaultSearchDelay = 1;

var setupEmberTest = function() {
  Ember.run(function() {
    if (App) {
      App.reset();
    }
  });
  resetFixtures();
}
