App.Router.map(function() {
  this.resource('editor', function() {
    this.route('show');
  });
});

App.LoadingRoute = Ember.Route.extend();

App.IndexRoute = Ember.Route.extend({
  redirect: function(e) {
    this.transitionTo("editor.show");
  }
});

App.EditorIndexRoute = Ember.Route.extend({
  redirect: function(e) {
    this.transitionTo("editor.show");
  }
});

