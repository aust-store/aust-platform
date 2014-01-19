App.ApplicationRoute = Ember.Route.extend({
  init: function() {
    var syncQueue = EmberSync.Queue.create({container: this});
    syncQueue.process();
  }
});

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('carts.new');
  }
});
