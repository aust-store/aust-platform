App.ApplicationRoute = Ember.Route.extend({
  init: function() {
    this._super();
    EmberSync.Queue.create({container: this}).process();
  }
});

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('carts.new');
  }
});
