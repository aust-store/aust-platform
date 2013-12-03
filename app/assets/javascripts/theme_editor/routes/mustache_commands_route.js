App.MustacheCommandsRoute = Ember.Route.extend({
  model: function() {
    return this.store.findAll("mustache_command");
  }
});
