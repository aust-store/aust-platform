App.Router.map(function() {
  this.resource('editor', function() {
    this.route('show');
  });
});

App.LoadingRoute = Ember.Route.extend();
App.ApplicationRoute = Ember.Route.extend();

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    return this.transitionTo("editor");
  }
});
