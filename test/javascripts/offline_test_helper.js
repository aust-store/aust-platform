//= require offline/application_manifest
//= require ./offline/setup
//= require ./offline/fixtures/online_data
//= require ./offline/fixtures/offline_data
//= require_tree ./helpers
//= require ./emberjs_test_helper
//= require_self

App.rootElement = '#qunit-fixture';
App.setupForTesting();
App.injectTestHelpers();
App.defaultSearchDelay = 0;

var setupEmberTest = function() {
  stop();
  Ember.run(function() {
    EmberSync.testing = true;

    IDB.deleteDatabase(testAdapterConfig.databaseName).then(function() {
      if (App) {
        App.reset();
        CustomFixtureSerializer.reopen({
          container: App.__container__
        });
        CustomFixtureAdapter.reopen({
          container: App.__container__
        });
      }
      start();
    });
  });
  resetFixtures();
}
