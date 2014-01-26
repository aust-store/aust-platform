App.ApplicationRoute = Ember.Route.extend({
  init: function() {
    this._super();

    var emberSync = EmberSync.API.create({container: this})
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
