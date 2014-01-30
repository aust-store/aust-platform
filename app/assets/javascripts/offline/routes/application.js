App.ApplicationRoute = Ember.Route.extend({
  init: function() {
    this._super();

    EmberSync.onError = function() {
      App.emberOffline.testServer();
    }

    App.emberOffline = App.EmberOffline.create();
    var emberSync = EmberSync.API.create({
      container: this
    })
    emberSync.synchronizeOnline();
    emberSync.offlineCache({
      models: [
        'inventoryItem',
      ]
    });
  }
});

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('carts.new');
  }
});
